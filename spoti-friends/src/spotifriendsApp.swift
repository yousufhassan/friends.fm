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
                    }
                }
        }
    }
}
