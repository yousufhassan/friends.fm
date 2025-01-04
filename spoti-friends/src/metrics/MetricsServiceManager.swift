import Foundation

class MetricsServiceManager {
    static let shared = MetricsServiceManager()
    private let metricsService: MetricsServiceProtocol
    
    init(metricsService: MetricsServiceProtocol = MixpanelMetricsService()) {
        self.metricsService = metricsService
    }
}
