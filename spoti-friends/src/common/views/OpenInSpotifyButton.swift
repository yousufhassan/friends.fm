import SwiftUI

/// A  View that creates a button to open a specified link in Spotify.
///
/// - Parameters:
///   - redirectLink: The Spotify link to redirect to on click.
struct OpenInSpotifyButton: View {
    let redirectLink: String
    
    var body: some View {
        Link(destination: URL(string: redirectLink)!) {
            HStack {
                HStack {
                    Image(.spotifyIconGreen)
                        .resizable()
                        .frame(width: 18, height: 18)
                    Text("Open in Spotify")
                        .foregroundStyle(Color.PresetColour.whitePrimary)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
            }
            .background(Color.PresetColour.spotifyBlack)
            .clipShape(.rect(cornerRadius: 20))
        }
    }
}

#Preview {
    OpenInSpotifyButton(redirectLink: "")
}
