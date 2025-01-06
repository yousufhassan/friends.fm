import Foundation

/// An enum of events to track and record metrics for.
enum MetricsEvent: String {
    case userSignedUp
    case appOpened
    case invitedUser
    case sharedSong
    case viewedProfile
    
    /// An enum to track the various event properties that may be tracked with an event.
    enum Properties: String {
        case viewContext
        case possibleUsers
        case receiversCount
        case nonUsersCount
        case ownProfile
    }
}


/// An enum to track the various views of the app that are relevant for metrics tracking purposes.
enum ViewContext: String {
    case nonUserProfileView
    case songShareAlert
    case receivedResourcesTab
}


