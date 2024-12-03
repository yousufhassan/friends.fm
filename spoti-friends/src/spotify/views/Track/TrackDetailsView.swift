import SwiftUI

struct TrackDetails: View {
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
    }
}

#Preview {
    TrackDetails(track: TrackMock.iRememberEverything)
}
