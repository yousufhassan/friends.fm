import SwiftUI

/// The View that renders a list of artists.
///
/// - Parameters:
///   - artists: The list of `Artist` objects to render as a list.
///
/// - Returns: A View that renders a list of artists.
struct ArtistList: View {
    let artists: [Artist]
    let showItemNumbers: Bool
    
    init(artists: [Artist], showItemNumbers: Bool = false) {
        self.artists = artists
        self.showItemNumbers = showItemNumbers
    }
    
    var body: some View {
        // Render loading placeholders while waiting for data
        if (artists.isEmpty) {
            TrackOrArtistListPlaceholder()
        }
        
        // Actual list once data is available
        else {
            VStack (alignment: .leading) {
                ForEach(artists.indices, id: \.self) { index in
                    let artist = artists[index]
                    
                    Link(destination: URL(string: artist.spotifyUri)!) {
                        HStack {
                            if (showItemNumbers) {
                                Text(String(index + 1))
                                    .foregroundStyle(Color.PresetColour.whiteSecondary)
                                    .font(.footnote)
                                    .frame(width: 20)
                                    .padding(.trailing, 2)
                            }
                            ImageWithSpecs(imageUrl: artist.image, width: 36, height: 36, cornerRadius: 2)
                            VStack (alignment: .leading) {
                                // Artist name
                                Text(artist.name)
                                    .font(.callout)
                                    .foregroundStyle(Color.PresetColour.whitePrimary)
                                    .lineLimit(1)
                                
                                // Artist genres
                                HStack(spacing: 0) {
                                    let genres = Array(artist.genres.prefix(2)) // Convert List<String> to [String]
                                    ForEach(genres.indices, id: \.self) { index in
                                        let genre = genres[index]
                                        
                                        Text(index < genres.count - 1
                                             ? "\(genre), "
                                             : genre)
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
//                        .animation(.easeInOut(duration: 0.6), value: artists)
                    }
                }
            }
        }
    }
}

#Preview {
    ZStack {
        let artists = [ArtistMock.zachBryan, ArtistMock.jonBellion, ArtistMock.oliviaRodrigo, ArtistMock.kaceyMusgraves]
        ArtistList(artists: artists)
    }
}
