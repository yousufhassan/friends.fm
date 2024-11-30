import SwiftUI

/// The View that renders the details for a listening activity item.
///
/// - Parameters:
///   - profile: The Spotify Profile for the user whose listening activity this is.
///   - currentTrack: The current or most recent track to display for the user.
///   - trackDetails: The actual `Track` object for the `currentTrack`.
///   - artist: The artist of `track`.
///   - context: The context from which `currentTrack` was played.
///
/// - Returns: A View for the Listening Activity Details.
struct ListeningActivityDetails: View {
    let profile: SpotifyProfile
    let currentTrack: CurrentOrMostRecentTrack
    let trackDetails: Track
    let artists: [Artist]
    let context: TrackContext?
    @State var contextIcon: Image
    
    init(profile: SpotifyProfile, currentTrack: CurrentOrMostRecentTrack) {
        self.profile = profile
        self.currentTrack = currentTrack
        self.trackDetails = currentTrack.track
        self.artists = currentTrack.track.artists
        self.context = currentTrack.track.context
        self.contextIcon = getImageForContextType()
        
        func getImageForContextType() -> Image {
            let contextType = currentTrack.track.context?.type
            
            switch contextType {
            case .album: return Image(systemName: "smallcircle.circle")
            case .artist: return Image(systemName: "person.fill")
            case .playlist: return Image(systemName: "music.note")
            default: return Image(systemName: "music.note")
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            // Username row
            HStack {
                Link(destination: URL(string: profile.spotifyUri)!) {
                    Text(profile.displayName)
                        .fontWeight(.medium)
                }
                Spacer()
                TrackTimestampView(nowPlaying: currentTrack.playedWithinLastFifteenMinutes,
                                   timestamp: currentTrack.timestamp)
            }
            
            // Song details row
            HStack(spacing: 4) {
                Link(destination: URL(string: trackDetails.spotifyUri)!) {
                    Text(trackDetails.name)
                        .lineLimit(1)
                        .layoutPriority(2)
                }
                
                Text("•")
                
                
                ForEach(artists.indices, id: \.self) { index in
                    let artist = artists[index]
                    Link(destination: URL(string: artist.spotifyUri)!) {
                        // Add comma except for the last artist
                        index < artists.count - 1 ? Text("\(artist.name),") : Text(artist.name)
                    }
                }
                .lineLimit(1)
                
            }
            
            // Context details row
            if let context = context {
                Link(destination: URL(string: context.spotifyUri)!) {
                    HStack {
                        contextIcon
                            .padding(.trailing, -6)
                        Text(trackDetails.context?.name ?? "")
                            .lineLimit(1)
                    }
                }
            }
        }
        .font(.system(size: 14))
        .fontWeight(.light)
    }
}

#Preview {
    ZStack {   
        let activity = ListeningActivityCardMock.michaelScottActivity
        ListeningActivityDetails(profile: activity.profile, currentTrack: activity.track)
    }
}
