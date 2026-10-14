import SwiftUI
import WidgetKit

struct StepEntry: TimelineEntry {
    let date: Date
    let snapshot: StepSnapshot
}

struct StepProvider: TimelineProvider {
    func placeholder(in context: Context) -> StepEntry {
        StepEntry(date: .now, snapshot: .sample)
    }

    func getSnapshot(in context: Context, completion: @escaping (StepEntry) -> Void) {
        let snap: StepSnapshot = context.isPreview ? .sample : (SnapshotStore.shared.load() ?? .sample)
        completion(StepEntry(date: .now, snapshot: snap))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<StepEntry>) -> Void) {
        Task {
            // Try Health directly; if the device is locked or Health is unreadable,
            // fall back to the last snapshot the app saved.
            var snap = await HealthReader.shared.refreshSnapshot()
                ?? SnapshotStore.shared.load()
                ?? .empty
            snap.goal = SnapshotStore.shared.goal

            let entry = StepEntry(date: .now, snapshot: snap)
            let next = Calendar.current.date(byAdding: .minute, value: 15, to: .now) ?? .now
            completion(Timeline(entries: [entry], policy: .after(next)))
        }
    }
}

struct AirStepsWidgetEntryView: View {
    let entry: StepEntry

    var body: some View {
        StepsCardView(snapshot: entry.snapshot)
            .padding(14)
            .widgetURL(URL(string: "airsteps://open"))
            .containerBackground(for: .widget) { Theme.background }
    }
}

struct AirStepsWidget: Widget {
    let kind = "AirStepsWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: StepProvider()) { entry in
            AirStepsWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("AirSteps")
        .description("Your Fitbit Air steps, with a little friend.")
        .supportedFamilies([.systemSmall])
        .contentMarginsDisabled()
    }
}

#Preview(as: .systemSmall) {
    AirStepsWidget()
} timeline: {
    StepEntry(date: .now, snapshot: .sample)
    StepEntry(date: .now, snapshot: StepSnapshot(steps: 8_420, goal: 8_000, updatedAt: .now, sourceName: "Google Health", status: .ok))
    StepEntry(date: .now, snapshot: StepSnapshot(steps: 900, goal: 8_000, updatedAt: .now, sourceName: "Google Health", status: .ok))
    StepEntry(date: .now, snapshot: .empty)
}
