import Foundation
import Mixpanel

class MixpanelMetricsService: MetricsServiceProtocol {
    init() {
        let signedInUser = 
        Mixpanel.mainInstance().identify(distinctId: )
    }
    
    private func track(event: MetricsEvent, properties: Properties? = nil) {
        Mixpanel.mainInstance().track(event: event.rawValue, properties: properties)
    }
    
    public func trackUserSignedUp(user: User) {
        self.track(event: .userSignedUp)
    }
}
