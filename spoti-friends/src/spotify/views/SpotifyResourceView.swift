import SwiftUI

// TODO: Add docs
struct SpotifyResourceView: View {
    let resource: SpotifyResource?
    var onTap: (() -> Void)?
    @State private var showSheet: Bool = false
    @State private var activeSheet: ActiveSheet = .actions
    
    init(resource: SpotifyResource?, onTap: (() -> Void)? = nil) {
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
                                            showSheet: $showSheet,
                                            sheet: $activeSheet)
            }
        }
    }
}

#Preview {
    SpotifyResourceView(resource: TrackMock.iRememberEverything)
}
