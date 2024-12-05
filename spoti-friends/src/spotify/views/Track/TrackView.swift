import SwiftUI

/// A View that displays a track with its album cover and details.
///
/// - Parameters:
///   - track: A `Track` object representing the track to be displayed.
///   - onTap: An action closure executed when the track is tapped. Default: opens the track in Spotify.
///
struct TrackView: View {
    let track: Track
    var onTap: (() -> Void)?
    
    init(track: Track, onTap: (() -> Void)? = nil) {
        self.track = track
        
        // Default behavior: open the track's Spotify URI
        self.onTap = onTap ?? {
            if let url = URL(string: track.spotifyUri) {
                UIApplication.shared.open(url)
                print("yo")
            }
        }
    }
    
    var body: some View {
        Button(action: {
            onTap?()
        }) {
            HStack {
                // Album cover
                ImageWithSpecs(imageUrl: track.album.image, width: 36, height: 36, cornerRadius: 2)
                
                TrackDetailsView(track: track)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 4)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    TrackView(track: TrackMock.traitor)
}
