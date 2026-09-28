import SwiftUI

#if os(macOS)
import AppKit
#endif

@main
struct MyApp: App {
    #if os(macOS)
    @Environment(\.openWindow) private var openWindow
    #endif

    var body: some Scene {
        #if os(macOS)
        Window("Desktop Organizer", id: "workspace") {
            ContentView()
        }

        MenuBarExtra("Desktop Organizer", systemImage: "square.grid.2x2") {
            Button("Open Workspace") {
                openWindow(id: "workspace")
                NSApp.activate(ignoringOtherApps: true)
            }

            Divider()

            Button("Quit Desktop Organizer") {
                NSApp.terminate(nil)
            }
        }
        #else
        WindowGroup {
            ContentView()
        }
        #endif
    }
}
