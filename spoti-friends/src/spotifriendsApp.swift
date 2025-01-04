import SwiftUI
import Mixpanel

@main
struct spoti_friendsApp: App {
    @StateObject private var authorizationViewModel = AuthorizationViewModel()
    
    init() {
        Mixpanel.initialize(token: "0c3a07f114762c672a4cebd9ee3f1fa3", trackAutomaticEvents: false)
        Mixpanel.mainInstance().identify(distinctId: "USER_ID")
         
        Mixpanel.mainInstance().people.set(properties: [
        "$name":"Jane Doe",
        "$email":"jane.doe@example.com",
        "$plan":"Premium"])
        
        Mixpanel.mainInstance().track(event:"Sign Up", properties: [
            "Signup Type": "Referral",
        ])
        
        printInfo("Set up done")
    }
    
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
///   - `signedInUser`
///   - `receivedResources`
///   - `sentResources`
///
/// - Parameter signedInUser: The currently signed-in user.
/// - Throws: An error if fetching the received or sent resources from `ShareServiceManager` fails.
///
func fetchAndCacheDataOnAppLoad(signedInUser: User) async throws {
    Cache.shared.cacheUser(signedInUser)
    printInfo("Cached signed in user")
    
    let userProfile = signedInUser.spotifyProfile
    let receivedResources = try await ShareServiceManager.shared.fetchReceivedResources(receiver: userProfile)
    Cache.shared.cacheReceivedResources(receivedResources, spotifyId: signedInUser.spotifyId)
    printInfo("Cached received resources for user (id=\(signedInUser.spotifyId))")
    
    let sentResources = try await ShareServiceManager.shared.fetchSentResources(sender: userProfile)
    Cache.shared.cacheSentResources(sentResources, spotifyId: signedInUser.spotifyId)
    printInfo("Cached sent resources for user (id=\(signedInUser.spotifyId))")
}
