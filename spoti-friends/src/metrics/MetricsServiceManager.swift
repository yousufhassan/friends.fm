import Foundation

class MetricsServiceManager {
    static let shared = MetricsServiceManager()
    private let metricsService: MetricsServiceProtocol
    
    init(metricsService: MetricsServiceProtocol = MixpanelMetricsService()) {
        self.metricsService = metricsService
    }
    
    /// Tracks when a new user signs up for the app.
    public func trackUserSignedUp() {
        self.metricsService.trackUserSignedUp()
    }
    
    /// Tracks when the app is opened.
    public func trackAppOpened() {
        self.metricsService.trackAppOpened()
    }
    
    /// Tracks when the "invite user" button is clicked and from which view.
    public func trackInivtedUser(viewContext: ViewContext, users: [SpotifyProfile]? = nil) {
        self.metricsService.trackInvitedUser(viewContext: viewContext, users: users)
    }
    
    /// Tracks when a user shares a song with friends.
    public func trackSharedSong(receiversCount: Int, nonUsersCount: Int) {
        self.metricsService.trackSharedSong(receiversCount: receiversCount, nonUsersCount: nonUsersCount)
    }
    
    /// Tracks when a user views a profile and whether or not it was their own profile view.
    public func trackViewedProfile(profile: SpotifyProfile) {
        self.metricsService.trackViewedProfile(profile: profile)
    }
}
