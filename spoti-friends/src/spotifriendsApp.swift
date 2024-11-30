import SwiftUI

@main
struct spoti_friendsApp: App {
    @StateObject private var authorizationViewModel = AuthorizationViewModel()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authorizationViewModel)
        }
    }
}
