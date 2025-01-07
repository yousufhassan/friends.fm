import Foundation
import Mixpanel

/// A service class for managing metrics and events tracking using Mixpanel.
///
/// This service supports distinct behavior for DEV and PROD environments:
/// - In DEV, it logs events to the console instead of recording them in Mixpanel.
/// - In PROD, it initializes Mixpanel and tracks metrics and events as configured.
///
class MixpanelMetricsService: MetricsServiceProtocol {
    private let MIXPANEL_TOKEN = "0c3a07f114762c672a4cebd9ee3f1fa3"
    
    init() {
        #if DEV
        printInfo("Identified DEV environment - not recording metrics.")
        return
        #endif
        
        // Ignore the IDE warning, the code will get executed in a PROD environment
        printInfo("Identified PROD environment - recording metrics.")
        Mixpanel.initialize(token: MIXPANEL_TOKEN, trackAutomaticEvents: false)
        
        let signedInUserId = getStringFromUserDefaultsValueForKey("signedInUserId")
        Mixpanel.mainInstance().identify(distinctId: signedInUserId)
    }
    
    /// Prints the metric event that was triggered when in DEV instead of writing to Mixpanel.
    private func recordMetricDevEnvironment(event: MetricsEvent, properties: Properties? = nil) {
        print("METRIC-DEV Event=\(event.rawValue) with Properties=\(String(describing: properties?.debugDescription))")
    }
    
    /// Marks an event that was triggered with any associated properties.
    ///
    /// - Parameters:
    ///   - event: The name of the metric event.
    ///   - properties: Optional. Additional properties to track associated with the event.
    ///
    /// - Note: When in a DEV environment, metrics are logged instead of recorded to Mixpanel.
    private func track(event: MetricsEvent, properties: Properties? = nil) {
        #if DEV
        self.recordMetricDevEnvironment(event: event, properties: properties)
        return
        #endif
        // Ignore the IDE warning, the code will get executed in a PROD environment
        Mixpanel.mainInstance().track(event: event.rawValue, properties: properties)
    }
    
    // -- Protocol methods --
    public func trackUserSignedUp(user: User) {
        let displayName = user.spotifyProfile.getDisplayName()
        let properties: Properties = [
            MetricsEvent.Properties.displayName.rawValue : displayName
        ]
        self.track(event: .userSignedUp, properties: properties)
    }
    
    public func trackAppOpened(by user: User) {
        let displayName = user.spotifyProfile.getDisplayName()
        let properties: Properties = [
            MetricsEvent.Properties.displayName.rawValue : displayName
        ]
        self.track(event: .appOpened, properties: properties)
    }
    
    public func trackInvitedUser(viewContext: ViewContext, users: [SpotifyProfile]? = nil) {
        let properties: Properties = [
            MetricsEvent.Properties.viewContext.rawValue : viewContext.rawValue,
            MetricsEvent.Properties.possibleUsers.rawValue: users?.map { $0.getSpotifyId() }
        ]
        self.track(event: .invitedUser, properties: properties)
    }
    
    public func trackSharedSong(receiversCount: Int, nonUsersCount: Int) {
        let properties: Properties = [
            MetricsEvent.Properties.receiversCount.rawValue : receiversCount,
            MetricsEvent.Properties.nonUsersCount.rawValue : nonUsersCount
        ]
        self.track(event: .sharedSong, properties: properties)
    }
    
    public func trackViewedProfile(profile: SpotifyProfile) {
        let viewedOwnProfile = profile.getSpotifyId() == Mixpanel.mainInstance().userId
        let properties: Properties = [
            MetricsEvent.Properties.ownProfile.rawValue : viewedOwnProfile
        ]
        self.track(event: .viewedProfile, properties: properties)
    }
}
