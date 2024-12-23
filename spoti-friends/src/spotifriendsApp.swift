import SwiftUI

@main
struct spoti_friendsApp: App {
    @StateObject private var authorizationViewModel = AuthorizationViewModel()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authorizationViewModel)
                .onAppear {
                    Task {
                        await authorizationViewModel.fetchAndUpdateUser()
                        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                            print("App Version: \(appVersion)")
                            storeInUserDefaults(key: "appVersion", value: appVersion)
                        }

                    }
                }
        }
    }
}
