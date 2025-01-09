import Foundation
import SwiftUI

/// Enum representing different types of actions that can be performed on a `SpotifyResource`.
///
/// Each case corresponds to a specific action, with associated properties such as icon, label, and a closure for the action itself.
/// This enum allows flexible selection of which actions to render in a given view.
enum ResourceActionType {
    case openInSpotify(showSheet: Binding<Bool>, resource: SpotifyResource)
    case addToQueue(showSheet: Binding<Bool>, resource: SpotifyResource, user: User, onError: (AddToQueueError) -> Void)
    case goToAlbum(showSheet: Binding<Bool>, track: Track)
    case goToArtist(showSheet: Binding<Bool>, track: Track)
    case markAsListened(showSheet: Binding<Bool>, sharedResource: SharedResource, shareViewModel: ShareViewModel)
    case markAsNotListened(showSheet: Binding<Bool>, sharedResource: SharedResource, shareViewModel: ShareViewModel)
    case unsend(showSheet: Binding<Bool>, sharedResource: SharedResource, shareViewModel: ShareViewModel)
    
    
    var icon: Image {
        switch self {
        case .openInSpotify:
            return Image(.spotifyIconGreen)
        case .addToQueue:
            return Image(systemName: "plus.circle")
        case .goToAlbum:
            return Image(systemName: "smallcircle.circle")
        case .goToArtist:
            return Image(.artistMusicNote)
        case .markAsListened:
            return Image(systemName: "checkmark.circle")
        case .markAsNotListened:
            return Image(systemName: "gobackward.minus")
        case .unsend:
            return Image(systemName: "trash")
        }
    }
    
    enum Label : String {
        case openInSpotify = "Open in Spotify"
        case addToQueue = "Add to queue"
        case goToAlbum = "Go to album"
        case goToArtist = "Go to artist"
        case markAsListened = "Mark as listened"
        case markAsNotListened = "Mark as not listened"
        case unsend = "Unsend"
    }
    
    var label: String {
        switch self {
        case .openInSpotify:
            return Label.openInSpotify.rawValue
        case .addToQueue:
            return Label.addToQueue.rawValue
        case .goToAlbum:
            return Label.goToAlbum.rawValue
        case .goToArtist:
            return Label.goToArtist.rawValue
        case .markAsListened:
            return Label.markAsListened.rawValue
        case .markAsNotListened:
            return Label.markAsNotListened.rawValue
        case .unsend:
            return Label.unsend.rawValue
        }
    }
    
    var action: () -> Void {
        switch self {
        case .openInSpotify(let showSheet, let resource):
            return {
                self.closeActionsSheet(showSheet: showSheet)
                if let url = URL(string: resource.getSpotifyUri()) {
                    UIApplication.shared.open(url)
                }
            }
        case .addToQueue(let showSheet, let resource, let user, let onError):
            return {
                let queryParams = [
                    URLQueryItem(name: "uri", value: resource.getSpotifyUri())
                ]
                let accessToken = user.getSpotifyWebAccessToken()
                Task {
                    do {
                        let _ = try await SpotifyAPI.shared.fetch(method: .POST,
                                                                  endpoint: .addItemToQueue,
                                                                  responseType: SpotifyAPI.VoidResponse.self,
                                                                  accessToken: accessToken.getAccessToken(),
                                                                  queryParams: queryParams)
                        
                        self.closeActionsSheet(showSheet: showSheet)
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
        case .goToAlbum(let showSheet, let track):
            return {
                self.closeActionsSheet(showSheet: showSheet)
                if let url = URL(string: track.album.getSpotifyUri()) {
                    UIApplication.shared.open(url)
                }
            }
        case .goToArtist(let showSheet, let track):
            return {
                self.closeActionsSheet(showSheet: showSheet)
                // Note: Only linked to the main artist for now
                if let url = URL(string: track.artists[0].getSpotifyUri()) {
                    UIApplication.shared.open(url)
                }
            }
        case .markAsListened(let showSheet, let sharedResource, let shareViewModel):
            return {
                Task {
                    await shareViewModel.markResourceAsListened(sharedResource)
                    self.closeActionsSheet(showSheet: showSheet)
                }
            }
        case .markAsNotListened(let showSheet, let sharedResource, let shareViewModel):
            return {
                Task {
                    await shareViewModel.markResourceAsNotListened(sharedResource)
                    self.closeActionsSheet(showSheet: showSheet)
                }
            }
        case .unsend(let showSheet, let sharedResource, let shareViewModel):
            return {
                Task {
                    await shareViewModel.unsendResource(sharedResource)
                    self.closeActionsSheet(showSheet: showSheet)
                }
            }
        }
    }
    
    /// Closes the resource actions sheet.
    func closeActionsSheet(showSheet: Binding<Bool>) {
        DispatchQueue.main.async {
            showSheet.wrappedValue = false
        }
    }
    
    // Preset action arrays for different contexts
    static func determineActions(showSheet: Binding<Bool>, resource: SpotifyResource,
                                 sharedResource: SharedResource? = nil,
                                 shareViewModel: ShareViewModel? = nil,
                                 user: User,
                                 onError: @escaping (AddToQueueError) -> Void) -> [ResourceActionType] {
        
        // Common actions that should always be present
        var actions: [ResourceActionType] = [
            .openInSpotify(showSheet: showSheet, resource: resource),
            .addToQueue(showSheet: showSheet, resource: resource, user: user, onError: onError),
        ]
        
        // If resource is a track, add those specific actions
        if (resource is Track) {
            let track = resource as! Track
            actions.append(.goToAlbum(showSheet: showSheet, track: track))
            actions.append(.goToArtist(showSheet: showSheet, track: track))
        }
        
        // If resource is a received resource, add those specific actions
        if (sharedResource != nil && sharedResource?.getReceiver().getSpotifyId() == user.spotifyId) {
            actions += receivedResourceActions(showSheet: showSheet,
                                               sharedResource: sharedResource!,
                                               shareViewModel: shareViewModel!,
                                               user: user,
                                               onError: onError)
        }
        
        // If resource is a sent resource, add those specific actions
        if (sharedResource != nil && sharedResource?.getSender().getSpotifyId() == user.spotifyId) {
            actions += sentResourceActions(showSheet: showSheet, sharedResource: sharedResource!, shareViewModel: shareViewModel!, user: user, onError: onError)
        }
        
        return actions
    }
    
    /// The set of actions available for a received resource.
    static func receivedResourceActions(showSheet: Binding<Bool>,
                                        sharedResource: SharedResource,
                                        shareViewModel: ShareViewModel,
                                        user: User,
                                        onError: @escaping (AddToQueueError) -> Void) -> [ResourceActionType] {
        let resource = sharedResource.getResource()!
        var actions: [ResourceActionType] = []
        
        sharedResource.isListened()
        ? actions.append(.markAsNotListened(showSheet: showSheet, sharedResource: sharedResource, shareViewModel: shareViewModel))
        : actions.append(.markAsListened(showSheet: showSheet, sharedResource: sharedResource, shareViewModel: shareViewModel))
        
        return actions
    }
    
    /// The set of actions available for a sent resource.
    static func sentResourceActions(showSheet: Binding<Bool>,
                                    sharedResource: SharedResource,
                                    shareViewModel: ShareViewModel,
                                    user: User,
                                    onError: @escaping (AddToQueueError) -> Void) -> [ResourceActionType] {
        let resource = sharedResource.getResource()!
        var actions: [ResourceActionType] = []
        
        actions.append(.unsend(showSheet: showSheet, sharedResource: sharedResource, shareViewModel: shareViewModel))
        return actions
    }
}
