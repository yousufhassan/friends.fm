import SwiftUI

/// A View that displays a track with its album cover and details.
///
/// - Parameters:
///   - track: A `Track` object representing the track to be displayed.
///
struct TrackView: View {
    let track: Track
    
    var body: some View {
        HStack {
            // Album cover
            ImageWithSpecs(imageUrl: track.album.image, width: 36, height: 36, cornerRadius: 2)
            
            TrackDetailsView(track: track)
        }
    }
}

#Preview {
    TrackView(track: TrackMock.iRememberEverything)
}
