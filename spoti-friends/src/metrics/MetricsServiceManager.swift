import Foundation

class MetricsServiceManager {
    static let shared = MetricsServiceManager()
    private let metricsService: MetricsServiceProtocol
    
    init(metricsService: MetricsServiceProtocol = MixpanelMetricsService()) {
        self.metricsService = metricsService
    }
    
    public func trackUserSignedUp(user: User) {
        self.metricsService.trackUserSignedUp(user: user)
    }
    
    public func trackAppOpened(by user: User) {
        self.metricsService.trackAppOpened(by: user)
    }
}
