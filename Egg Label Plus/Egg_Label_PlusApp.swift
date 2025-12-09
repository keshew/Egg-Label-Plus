import SwiftUI

@main
struct Egg_Label_PlusApp: App {
    @StateObject private var historyVM = HistoryViewModel()
    @StateObject private var favoritesVM = FavoritesViewModel()
    @StateObject private var settingsVM = SettingsViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(historyVM)
                .environmentObject(favoritesVM)
                .environmentObject(settingsVM)
        }
    }
}
