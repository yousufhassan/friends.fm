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
                ForEach(tracks.indices) { index in
                    let track = tracks[index]
                    HStack {
                        if (showItemNumbers) {
                            Text(String(index + 1))
                                .foregroundStyle(Color.PresetColour.whiteSecondary)
                                .font(.footnote)
                                .frame(width: 20)
                                .padding(.trailing, 2)
                        }
                        
                        TrackView(track: track)
                        
                        Spacer() // To left align the content
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
