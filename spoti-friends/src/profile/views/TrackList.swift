import SwiftUI

/// The View that renders a list of tracks.
///
/// - Parameters:
///   - tracks: The list of `Track` objects to render as a list.
///
/// - Returns: A View that renders a list of tracks.
struct TrackList: View {
    let tracks: [Track]
    let showItemNumbers: Bool
    
    init(tracks: [Track], showItemNumbers: Bool = false) {
        self.tracks = tracks
        self.showItemNumbers = showItemNumbers
    }
    
    var body: some View {
        // Render loading placeholders while waiting for data
        if (tracks.isEmpty) {
            TrackOrArtistListPlaceholder()
        }
        
        // Actual list once data is available
        else {
            VStack (alignment: .leading) {
                ForEach(tracks.indices, id: \.self) { index in
                    let track = tracks[index]
                    
                    Link(destination: URL(string: track.spotifyUri)!) {
                        HStack {
                            if (showItemNumbers) {
                                Text(String(index + 1))
                                    .foregroundStyle(Color.PresetColour.whiteSecondary)
                                    .font(.footnote)
                                    .frame(width: 20)
                                    .padding(.trailing, 2)
                            }
                            ImageWithSpecs(imageUrl: track.album?.image ?? "", width: 36, height: 36, cornerRadius: 2)
                            
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
                                .lineLimit(1)
                            }
                            
                            Spacer() // To left align the content
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 4)
                    }
                }
            }
        }
    }
}

#Preview {
    ZStack {
        let tracks = [TrackMock.luxury, TrackMock.iRememberEverything, TrackMock.traitor]
        TrackList(tracks: tracks)
    }
}
