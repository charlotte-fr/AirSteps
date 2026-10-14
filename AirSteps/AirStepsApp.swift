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
                .onOpenURL { url in
                    // airsteps://sync  (the widget's tap target). Only bounce to
                    // Google Health once setup is done; otherwise stay here.
                    if url.host == "sync", model.snapshot.status == .ok {
                        model.openGoogleHealth()
                    }
                }
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active { Task { await model.refresh() } }
        }
    }
}
