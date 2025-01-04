import Foundation

/// A protocol that defines the methods for tracking relevant metrics.
protocol MetricsServiceProtocol {
    // Track when a new user signs up
    func trackUserSignedUp(user: User)
}
