import Foundation

/// A protocol that defines the methods for tracking relevant metrics.
protocol MetricsServiceProtocol {
    /// Tracks when a new user signs up for the app.
    func trackUserSignedUp(user: User)
    
    /// Tracks when the app is opened and by whom.
    func trackAppOpened(by: User)
    
    /// Tracks when the "invite user" button is clicked and from which view.
    func trackInvitedUser(viewContext: ViewContext, users: [SpotifyProfile]?)
    
    /// Tracks when a user shares a song with friends.
    func trackSharedSong(receiversCount: Int, nonUsersCount: Int)
    
    /// Tracks when a user views a profile and whether or not it was their own profile view.
    func trackViewedProfile(profile: SpotifyProfile)
}
