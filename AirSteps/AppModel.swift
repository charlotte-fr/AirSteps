import SwiftUI
import HealthKit
import WidgetKit

@MainActor
final class AppModel: ObservableObject {
    @Published var snapshot: StepSnapshot = SnapshotStore.shared.load() ?? .empty
    @Published var sources: [HKSource] = []
    @Published var healthGranted = SnapshotStore.shared.didRequestHealth
    @Published var goal: Int = SnapshotStore.shared.goal

    private let health = HealthReader.shared

    init() {
        health.startBackgroundUpdates()
    }

    func requestHealth() async {
        do {
            try await health.requestAuthorization()
            SnapshotStore.shared.didRequestHealth = true
            healthGranted = true
            await refresh()
        } catch {
            healthGranted = false
        }
    }

    func refresh() async {
        guard health.isAvailable else { return }
        sources = (try? await health.stepSources()) ?? []
        if let fresh = await health.refreshSnapshot() {
            snapshot = fresh
        }
        WidgetCenter.shared.reloadAllTimelines()
    }

    func setGoal(_ newGoal: Int) {
        guard newGoal != goal else { return }
        goal = newGoal
        SnapshotStore.shared.goal = newGoal
        snapshot.goal = newGoal
        SnapshotStore.shared.save(snapshot)
        WidgetCenter.shared.reloadAllTimelines()
    }

    func select(source: HKSource) {
        SnapshotStore.shared.sourceBundleID = source.bundleIdentifier
        Task { await refresh() }
    }

    var selectedSourceID: String? {
        SnapshotStore.shared.sourceBundleID
            ?? sources.first(where: HealthReader.looksLikeFitbit)?.bundleIdentifier
    }

    /// Opening Google Health forces the Fitbit Air to sync right away.
    func openGoogleHealth() {
        let candidates = ["googlehealth://", "fitbit://",
                          "https://apps.apple.com/app/id462638897"]
        for s in candidates {
            if let url = URL(string: s), UIApplication.shared.canOpenURL(url) || s.hasPrefix("https") {
                UIApplication.shared.open(url)
                return
            }
        }
    }
}
