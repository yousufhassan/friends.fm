import Foundation

/// A protocol that defines the methods for tracking relevant metrics.
protocol MetricsServiceProtocol {
    /// Tracks when a new user signs up for the app.
    func trackUserSignedUp()
    
    /// Tracks when the app is opened.
    func trackAppOpened()
    
    /// Tracks when the "invite user" button is clicked and from which view.
    func trackInvitedUser(viewContext: ViewContext, users: [SpotifyProfile]?)
}
