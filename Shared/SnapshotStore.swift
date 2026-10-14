import Foundation

enum AppGroup {
    /// Must match the App Group in both entitlements files.
    static let id = "group.com.axitetech.airsteps"
}

/// Tiny key-value store shared between the app and the widget.
final class SnapshotStore {
    static let shared = SnapshotStore()

    private let defaults: UserDefaults
    private let snapshotKey = "snapshot"
    private let goalKey = "goal"
    private let sourceKey = "sourceBundleID"
    private let askedKey = "didRequestHealth"

    init() {
        defaults = UserDefaults(suiteName: AppGroup.id) ?? .standard
    }

    var goal: Int {
        get { let g = defaults.integer(forKey: goalKey); return g > 0 ? g : 8_000 }
        set { defaults.set(newValue, forKey: goalKey) }
    }

    /// True once the app has shown the Health permission sheet.
    var didRequestHealth: Bool {
        get { defaults.bool(forKey: askedKey) }
        set { defaults.set(newValue, forKey: askedKey) }
    }

    /// Bundle id of the Apple Health source we trust (Google Health / Fitbit).
    var sourceBundleID: String? {
        get { defaults.string(forKey: sourceKey) }
        set { defaults.set(newValue, forKey: sourceKey) }
    }

    func load() -> StepSnapshot? {
        guard let data = defaults.data(forKey: snapshotKey) else { return nil }
        return try? JSONDecoder().decode(StepSnapshot.self, from: data)
    }

    func save(_ snapshot: StepSnapshot) {
        if let data = try? JSONEncoder().encode(snapshot) {
            defaults.set(data, forKey: snapshotKey)
        }
    }
}
