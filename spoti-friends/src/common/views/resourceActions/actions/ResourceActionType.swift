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
    case addToQueue(resource: SpotifyResource, user: User, onError: (AddToQueueError) -> Void)
    
    var icon: Image {
        switch self {
        case .openInSpotify:
            return Image(.spotifyIconGreen)
        case .addToQueue:
            return Image(systemName: "plus.circle")
        }
    }
    
    var label: String {
        switch self {
        case .openInSpotify:
            return "Open in Spotify"
        case .addToQueue:
            return "Add to queue"
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
        case .addToQueue(let resource, let user, let onError):
            return {
                let queryParams = [
                    URLQueryItem(name: "uri", value: resource.getSpotifyUri())
                ]
                let accessToken = user.getSpotifyWebAccessToken()
                Task {
                    do {
                        let _ = try await SpotifyAPI.shared.fetch(method: .POST,
                                                                         endpoint: .addItemToQueue,
                                                                         responseType: String.self,
                                                                         accessToken: accessToken.getAccessToken(),
                                                                         queryParams: queryParams)
                    } catch let error as SpotifyAPIError {
                        switch error {
                        case .forbidden:
                            onError(.premiumRequired)
                        case .notFound:
                            onError(.noActiveDevice)
                        default:
                            onError(.unknown)
                        }
                    }
                }
            }
        }
    }
    
    // Preset action arrays for different contexts
    static func receivedResourceActions(resource: SpotifyResource,
                                        user: User,
                                        onError: @escaping (AddToQueueError) -> Void) -> [ResourceActionType] {
        return [
            .openInSpotify(resource: resource),
            .addToQueue(resource: resource, user: user, onError: onError)
        ]
    }
}
