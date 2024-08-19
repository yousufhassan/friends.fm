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
                            Text(track.name)
                                .foregroundStyle(Color.PresetColour.whitePrimary)
                                .lineLimit(1)
                            Text(track.artist?.name ?? "Error")
                                .font(.subheadline)
                                .foregroundStyle(Color.PresetColour.whiteSecondary)
                        }
                    }
                    .padding(.leading, 8)
                    .padding(.vertical, 4)
                }
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    let trackList = [TrackMock.luxury, TrackMock.iRememberEverything, TrackMock.traitor]
    TrackOrArtistList(trackList: trackList)
}
