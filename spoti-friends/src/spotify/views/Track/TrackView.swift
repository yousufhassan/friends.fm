import SwiftUI

struct TrackView: View {
    let track: Track
    
    var body: some View {
        HStack {
            // Album cover
            ImageWithSpecs(imageUrl: track.album.image, width: 36, height: 36, cornerRadius: 2)
            
            TrackDetails(track: track)
        }
    }
}

#Preview {
    TrackView(track: TrackMock.iRememberEverything)
}
