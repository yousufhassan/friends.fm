import SwiftUI

/// The View that renders a list of either tracks or artists.
///
/// - Parameters:
///
/// - Returns: A View for the album cover image.
struct TrackOrArtistList: View {
    let trackList: [Track]
    var body: some View {
        HStack {
            VStack (alignment: .leading) {
                Text("Recent Songs")
                    .font(.title3)
                    .foregroundStyle(Color.PresetColour.whitePrimary)
                
                
                ForEach(trackList) { track in
                    HStack {
                        AlbumCover(album: track.album, width: 36, height: 36, cornerRadius: 2)
                        
                        VStack (alignment: .leading) {
                            // Track name
                            Text(track.name)
                                .font(.body)
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
            
            Spacer()
        }
    }
}

#Preview {
    let trackList = [TrackMock.luxury, TrackMock.iRememberEverything, TrackMock.traitor]
    TrackOrArtistList(trackList: trackList)
}
