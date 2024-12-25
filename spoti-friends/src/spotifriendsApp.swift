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
                        guard let signedInUser = authorizationViewModel.user else {
                            throw AuthorizationError.missingUser
                        }
                        
                        try await fetchAndCacheDataOnAppLoad(signedInUser: signedInUser)
                    }
                }
        }
    }
}

/// Fetches and caches data for the signed-in user during app load.
///
/// This function fetches and caches the following data:
///   - `receivedResources`
///   - `sentResources`
///
/// - Parameter signedInUser: The currently signed-in user.
/// - Throws: An error if fetching the received or sent resources from `ShareServiceManager` fails.
///
func fetchAndCacheDataOnAppLoad(signedInUser: User) async throws {
    let receivedResources = try await ShareServiceManager.shared.fetchReceivedResources(receiver: signedInUser)
    let sentResources = try await ShareServiceManager.shared.fetchSentResources(sender: signedInUser)
    Cache.shared.cacheReceivedResources(receivedResources, forKey: signedInUser.spotifyId)
    Cache.shared.cacheSentResources(sentResources, forKey: signedInUser.spotifyId)
    printInfo("Cached received resources for user (id=\(signedInUser.spotifyId))")
    printInfo("Cached sent resources for user (id=\(signedInUser.spotifyId))")
}
