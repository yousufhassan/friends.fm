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
                            
                            try await fetchAndCacheDataOnAppLoad(signedInUser: signedInUser)
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

/// Fetches and caches data for the signed-in user during app load.
///
/// This function fetches and caches the following data:
///   - `signedInUser`
///   - `receivedResources`
///   - `sentResources`
///
/// - Parameter signedInUser: The currently signed-in user.
/// - Throws: An error if fetching the received or sent resources from `ShareServiceManager` fails.
///
func fetchAndCacheDataOnAppLoad(signedInUser: User) async throws {
    PersistedStorage.shared.persistUser(signedInUser)
    printInfo("Persisted signed in user")
    
    let userProfile = signedInUser.spotifyProfile
    let receivedResources = try await ShareServiceManager.shared.fetchReceivedResources(receiver: userProfile)
    Cache.shared.cacheReceivedResources(receivedResources, spotifyId: signedInUser.spotifyId)
    printInfo("Cached received resources for user (id=\(signedInUser.spotifyId))")
    
    let sentResources = try await ShareServiceManager.shared.fetchSentResources(sender: userProfile)
    Cache.shared.cacheSentResources(sentResources, spotifyId: signedInUser.spotifyId)
    printInfo("Cached sent resources for user (id=\(signedInUser.spotifyId))")
}
