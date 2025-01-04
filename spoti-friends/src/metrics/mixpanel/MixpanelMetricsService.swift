import Foundation
import Mixpanel

class MixpanelMetricsService: MetricsServiceProtocol {
    private let MIXPANEL_TOKEN = "0c3a07f114762c672a4cebd9ee3f1fa3"
    
    init() {
        Mixpanel.initialize(token: MIXPANEL_TOKEN, trackAutomaticEvents: false)
        
        let signedInUserId = getStringFromUserDefaultsValueForKey("signedInUserId")
        Mixpanel.mainInstance().identify(distinctId: signedInUserId)
    }
    
    private func track(event: MetricsEvent, properties: Properties? = nil) {
        Mixpanel.mainInstance().track(event: event.rawValue, properties: properties)
    }
    
    public func trackUserSignedUp(user: User) {
        self.track(event: .userSignedUp)
    }
    
    public func trackAppOpened(by user: User) {
        self.track(event: .appOpened)
    }
}
