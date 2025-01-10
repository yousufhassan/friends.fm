import SwiftUI

@main
struct spoti_friendsApp: App {
    @StateObject private var authorizationViewModel = AuthorizationViewModel()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                RootView()
                    .environmentObject(authorizationViewModel)
                    .onAppear {
                        Task {
                            await authorizationViewModel.fetchAndUpdateUser()
                            guard let signedInUser = authorizationViewModel.user else {
                                throw AuthorizationError.missingUser
                            }
                            MetricsServiceManager.shared.trackAppOpened(by: signedInUser)
                            
                            if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                                print("App Version: \(appVersion)")
                                storeInUserDefaults(key: "appVersion", value: appVersion)
                            }
                        }
                    }
                
                // Conditionally render a modal that says the user needs to reauthenticate
                if (authorizationViewModel.isReauthenticationRequired) {
                    Color.black.opacity(0.6)
                        .ignoresSafeArea()
                    ReauthenticationRequiredModal()
                        .environmentObject(authorizationViewModel)
                }
            }
        }
    }
}
