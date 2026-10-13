import Foundation
import HealthKit
import WidgetKit

/// Reads today's steps from Apple Health, restricted to the Fitbit / Google
/// Health source so the iPhone's own motion counts are never mixed in.
final class HealthReader {
    static let shared = HealthReader()

    private let store = HKHealthStore()
    private let stepType = HKQuantityType(.stepCount)
    private var observer: HKObserverQuery?

    var isAvailable: Bool { HKHealthStore.isHealthDataAvailable() }

    func requestAuthorization() async throws {
        try await store.requestAuthorization(toShare: [], read: [stepType])
    }

    // MARK: Sources

    /// Every app or device that has written steps into Apple Health.
    func stepSources() async throws -> [HKSource] {
        try await withCheckedThrowingContinuation { cont in
            let query = HKSourceQuery(sampleType: stepType, samplePredicate: nil) { _, sources, error in
                if let error { cont.resume(throwing: error); return }
                cont.resume(returning: Array(sources ?? []))
            }
            store.execute(query)
        }
    }

    static func looksLikeFitbit(_ source: HKSource) -> Bool {
        let id = source.bundleIdentifier.lowercased()
        let name = source.name.lowercased()
        return id.contains("fitbit") || name.contains("fitbit")
            || id.contains("google.health") || id.contains("googlehealth")
            || name.contains("google health")
    }

    /// The saved source, or the first one that looks like Fitbit / Google Health.
    func fitbitSource() async throws -> HKSource? {
        let sources = try await stepSources()
        if let saved = SnapshotStore.shared.sourceBundleID,
           let match = sources.first(where: { $0.bundleIdentifier == saved }) {
            return match
        }
        return sources.first(where: Self.looksLikeFitbit)
    }

    // MARK: Steps

    func todaySteps(from source: HKSource) async throws -> Int {
        let start = Calendar.current.startOfDay(for: .now)
        let datePredicate = HKQuery.predicateForSamples(withStart: start, end: .now, options: .strictStartDate)
        let sourcePredicate = HKQuery.predicateForObjects(from: source)
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [datePredicate, sourcePredicate])

        return try await withCheckedThrowingContinuation { cont in
            let query = HKStatisticsQuery(quantityType: stepType,
                                          quantitySamplePredicate: predicate,
                                          options: .cumulativeSum) { _, stats, error in
                if let error { cont.resume(throwing: error); return }
                let value = stats?.sumQuantity()?.doubleValue(for: .count()) ?? 0
                cont.resume(returning: Int(value.rounded()))
            }
            store.execute(query)
        }
    }

    /// Query Health, save the result to the App Group, return it.
    /// Returns nil when Health could not be read (e.g. device locked), so the
    /// caller can fall back to the last saved snapshot.
    @discardableResult
    func refreshSnapshot() async -> StepSnapshot? {
        guard isAvailable else { return nil }
        let goal = SnapshotStore.shared.goal
        do {
            guard let source = try await fitbitSource() else {
                let snap = StepSnapshot(steps: 0, goal: goal, updatedAt: .now,
                                        sourceName: nil, status: .noSource)
                SnapshotStore.shared.save(snap)
                return snap
            }
            let steps = try await todaySteps(from: source)
            let snap = StepSnapshot(steps: steps, goal: goal, updatedAt: .now,
                                    sourceName: source.name, status: .ok)
            SnapshotStore.shared.save(snap)
            return snap
        } catch {
            return nil
        }
    }

    // MARK: Background updates (app only)

    /// Ask HealthKit to wake the app when new step samples arrive, then push
    /// a fresh snapshot to the widget. Call once at app launch.
    func startBackgroundUpdates() {
        guard isAvailable, observer == nil else { return }
        store.enableBackgroundDelivery(for: stepType, frequency: .hourly) { _, _ in }
        let query = HKObserverQuery(sampleType: stepType, predicate: nil) { [weak self] _, completion, _ in
            Task {
                _ = await self?.refreshSnapshot()
                WidgetCenter.shared.reloadAllTimelines()
                completion()
            }
        }
        observer = query
        store.execute(query)
    }
}
