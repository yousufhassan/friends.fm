import SwiftUI

/// A View that displays information about a track such as the track name and its artists.
///
/// - Parameters:
///   - track: A `Track` object representing the track to display details for.
///
struct TrackDetailsView: View {
    let track: Track
    
    var body: some View {
        VStack(alignment: .leading) {
            // Track name
            Text(track.name)
                .font(.callout)
                .foregroundStyle(Color.PresetColour.whitePrimary)
                .lineLimit(1)
            
            // Artist names
            HStack(spacing: 0) {
                let artistsArray = track.artists
                ForEach(artistsArray.indices, id: \.self) { index in
                    let artist = artistsArray[index]
                    
                    Text(index < artistsArray.count - 1
                         ? "\(artist.name), "
                         : artist.name)
                    .font(.footnote)
                    .foregroundStyle(Color.PresetColour.whiteSecondary)
                }
            }
            .lineLimit(1)
        }
    }
}

#Preview {
    TrackDetailsView(track: TrackMock.iRememberEverything)
}
