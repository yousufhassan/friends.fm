import Foundation
import SwiftUI

/// Enum representing different types of actions that can be performed on a `SpotifyResource`.
///
/// Each case corresponds to a specific action, with associated properties such as icon, label, and a closure for the action itself.
/// This enum allows flexible selection of which actions to render in a given view.
///
/// Available actions:
/// - `openInSpotify`: Opens the resource in the Spotify app using the Spotify URI.
///
enum ResourceActionType {
    case openInSpotify(resource: SpotifyResource)
    
    var icon: Image {
        switch self {
        case .openInSpotify:
            return Image(.spotifyIconGreen)
        }
    }
    
    var label: String {
        switch self {
        case .openInSpotify:
            return "Open in Spotify"
        }
    }
    
    var action: () -> Void {
        switch self {
        case .openInSpotify(let resource):
            return {
                if let url = URL(string: resource.getSpotifyUri()) {
                    UIApplication.shared.open(url)
                }
            }
        }
    }
    
    // Preset action arrays for different contexts
    static var receivedResourceActions: [ResourceActionType] {
        return [
            .openInSpotify(resource: TrackMock.traitor)
        ]
    }
}
