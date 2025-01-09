import SwiftUI

/// A  View displaying a Spotify resource, such as a track or artist.
///
/// `SpotifyResourceView` renders a preview of the resource and provides functionality for interacting with it,
/// such as opening an action sheet or triggering a custom tap action. Depending on the type of resource, the appropriate
/// view is rendered.
///
/// - Parameters:
///   - resource: The `SpotifyResource` object to display.
///   - sharedResource: An optional `SharedResource` associated with the Spotify resource.
///   - shareViewModel: An optional `ShareViewModel` to manage shared resource interactions.
///   - onTap: An optional closure executed when the view is tapped. Defaults to opening the action sheet.
///
/// - Note: `sharedResource` and `shareViewModel` are only passed in for the purpose of having some functionality
///          related to `SharedResources` available in the action sheet. If the context does not require a `SharedResource`,
///          the caller will/should not pass it in.
struct SpotifyResourceView: View {
    let resource: SpotifyResource?
    let sharedResource: SharedResource?
    var shareViewModel: ShareViewModel?
    
    var onTap: (() -> Void)?
    @State var showSheet: Bool = false
    @State var activeSheet: ActiveSheet = .actions
    
    init(resource: SpotifyResource?, sharedResource: SharedResource? = nil, shareViewModel: ShareViewModel? = nil,
         onTap: (() -> Void)? = nil) {
        self.sharedResource = sharedResource
        self.shareViewModel = shareViewModel
        
        if let resource = resource {
            self.resource = resource
            self.onTap = onTap
        }
        else {
            self.resource = nil
            self.onTap = nil
        }
    }
    
    var body: some View {
        if (resource == nil) {
            TrackOrArtistViewPlaceholder()
        } else {
            Button(action: {
                if (onTap == nil) {
                    // Defaults to opening the action sheet
                    self.showSheet = true
                    self.activeSheet = .actions
                } else {
                    onTap?()
                }
            }) {
                if (resource is Track) {
                    let track = resource as! Track
                    TrackView(track: track)
                }
            }
            .buttonStyle(.plain)
            .sheet(isPresented: $showSheet) {
                ResourceActionsOrErrorSheet(resource: resource,
                                            sharedResource: sharedResource,
                                            shareViewModel: shareViewModel,
                                            showSheet: $showSheet,
                                            sheet: $activeSheet)
            }
        }
    }
}

#Preview {
    SpotifyResourceView(resource: TrackMock.iRememberEverything)
}
