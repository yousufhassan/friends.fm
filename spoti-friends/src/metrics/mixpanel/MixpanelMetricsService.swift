import Foundation
import Mixpanel

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
    
    /// Tracks when a new user signs up for the app.
    public func trackUserSignedUp(user: User) {
        self.track(event: .userSignedUp)
    }
    
    /// Tracks when the app is opened.
    public func trackAppOpened(by user: User) {
        self.track(event: .appOpened)
    }
}
