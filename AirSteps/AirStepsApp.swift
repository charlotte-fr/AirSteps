import SwiftUI
import WidgetKit

@main
struct AirStepsApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var model = AppModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
                .onOpenURL { _ in
                    // airsteps://open (the widget's tap target): just land in
                    // the app and refresh. Syncing Google Health is a button here.
                    Task { await model.refresh() }
                }
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active { Task { await model.refresh() } }
        }
    }
}
