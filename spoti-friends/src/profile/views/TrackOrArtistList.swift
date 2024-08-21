import SwiftUI

/// The View that renders a list of either tracks or artists.
///
/// - Parameters:
///
/// - Returns: A View for the album cover image.
struct TrackOrArtistList: View {
    let trackList: [ProfileViewModel.GetCurrentUserTopTracks.Track2]
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
                                ForEach(track.artists.indices, id: \.self) { index in
                                    let artist = track.artists[index]
                                    
                                    index < track.artists.count - 1
                                    ? Text("\(artist?.name ?? ""), ")
                                    : Text(artist?.name ?? "")
                                    
                                }
                                .font(.footnote)
                                .foregroundStyle(Color.PresetColour.whiteSecondary)
                            }
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
    //    TrackOrArtistList(trackList: trackList)
}
