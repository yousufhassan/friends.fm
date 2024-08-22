import SwiftUI

/// The View that renders a list of either tracks or artists.
///
/// - Parameters:
///   - trackList: The list of `Track` objects to render as a list.
///
/// - Returns: A View that renders a list of either tracks or artists.
struct TrackOrArtistList: View {
    let trackList: [Track]
    var body: some View {
        VStack (alignment: .leading) {
            ForEach(trackList) { track in
                HStack {
                    AlbumCover(album: track.album, width: 36, height: 36, cornerRadius: 2)
                    
                    VStack (alignment: .leading) {
                        // Track name
                        Text(track.name)
                            .font(.callout)
                            .foregroundStyle(Color.PresetColour.whitePrimary)
                            .lineLimit(1)
                        
                        // Artist names
                        HStack(spacing: 0) {
                            let artistsArray = Array(track.artists) // Convert List<Artist> to [Artist]
                            ForEach(artistsArray.indices, id: \.self) { index in
                                let artist = artistsArray[index]
                                
                                Text(index < artistsArray.count - 1
                                     ? "\(artist.name), "
                                     : artist.name)
                                .font(.footnote)
                                .foregroundStyle(Color.PresetColour.whiteSecondary)
                            }
                        }
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }
}

#Preview {
    let trackList = [TrackMock.luxury, TrackMock.iRememberEverything, TrackMock.traitor]
    TrackOrArtistList(trackList: trackList)
}
