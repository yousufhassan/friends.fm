//
//  ArtistList.swift
//  spoti-friends
//
//  Created by Yousuf Hassan on 2024-08-28.
//

import SwiftUI

struct ArtistList: View {
    let artists: [Artist]
    var body: some View {
        // Render loading placeholders while waiting for data
        if (artists.isEmpty) {
            TrackOrArtistListPlaceholder()
        }
        
        // Actual list once data is available
        else {
            VStack (alignment: .leading) {
                ForEach(artists) { artist in
                    Link(destination: URL(string: artist.spotifyUri)!) {
                        HStack {
                            ImageWithSpecs(imageUrl: artist.image, width: 36, height: 36, cornerRadius: 2)
                            VStack (alignment: .leading) {
                                // Artist name
                                Text(artist.name)
                                    .font(.callout)
                                    .foregroundStyle(Color.PresetColour.whitePrimary)
                                    .lineLimit(1)
                                
                                // Artist genres
                                HStack(spacing: 0) {
                                    let genres = Array(artist.genres.prefix(3)) // Convert List<String> to [String]
                                    ForEach(genres.indices, id: \.self) { index in
                                        let genre = genres[index]
                                        
                                        Text(index < genres.count - 1
                                             ? "\(genre), "
                                             : genre)
                                        .font(.footnote)
                                        .foregroundStyle(Color.PresetColour.whiteSecondary)
                                    }
                                }
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
        let artists = [ArtistMock.zachBryan, ArtistMock.jonBellion, ArtistMock.oliviaRodrigo, ArtistMock.kaceyMusgraves]
        ArtistList(artists: artists)
    }
}
