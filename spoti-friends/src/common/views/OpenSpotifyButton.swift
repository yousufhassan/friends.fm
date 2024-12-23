import SwiftUI

/// A  View that creates a button to open a specified link in Spotify.
///
/// - Parameters:
///   - buttonText: The text to display on the button.
///   - redirectLink: The Spotify link to redirect to on click.
struct OpenSpotifyButton: View {
    let buttonText: String
    let redirectLink: String
    let size: ButtonSize
    
    init(buttonText: String = "Open Spotify", redirectLink: String? = nil, size: ButtonSize = .medium) {
        let defaultSpotifyUrl = "spotify:track:*"
        self.buttonText = buttonText
        self.redirectLink = redirectLink ?? defaultSpotifyUrl
        self.size = size
    }
    
    var body: some View {
        Link(destination: URL(string: redirectLink)!) {
            HStack {
                HStack {
                    Image(.spotifyIconGreen)
                        .resizable()
                        .frame(width: 18, height: 18)
                    Text(buttonText)
                        .foregroundStyle(Color.PresetColour.whitePrimary)
                }
                .padding(.horizontal, size.horizontalPadding)
                .padding(.vertical, size.verticalPadding)
            }
            .background(Color.PresetColour.spotifyBlack)
            .clipShape(.rect(cornerRadius: size.cornerRadius))
        }
    }
}

#Preview {
    OpenSpotifyButton()
}

enum ButtonSize {
    case small
    case medium
    //    case large
    
    var horizontalPadding: CGFloat {
        switch self {
        case .small: return 12
        case .medium: return 32
        }
    }
    
    var verticalPadding: CGFloat {
        switch self {
        case .small: return 6
        case .medium: return 12
        }
    }
    
    var cornerRadius: CGFloat {
        switch self {
        case .small: return 20
        default: return 100
        }
    }

}
