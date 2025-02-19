import SwiftUI

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            MainMenuView().frame(width: 1250, height: 820)
        }.windowResizability(.contentSize)
    }
}
