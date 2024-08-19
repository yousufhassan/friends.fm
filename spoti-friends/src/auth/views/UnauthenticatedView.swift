import SwiftUI

/// This is the view rendered for when the user opens the application and is not signed in.
struct UnauthenticatedView: View {
    @EnvironmentObject private var authorizationViewModel: AuthorizationViewModel
    @State private var showWebView = false
    @State private var responseUrl: URL?
    
    var body: some View {
        VStack() {
            // Title and subtitle
            SignInTitle()
            
            // For the empty space in the middle of the view
            Spacer().frame(height: 320)
                        
            // Sign in button
            SignInButton(showWebView: $showWebView, responseUrl: $responseUrl)
            
            Spacer()  // To have some empty space at the bottom
        }
        .padding()
        .background(backgroundGradient)
    }
}

/// The title view that renders the "Spotifriends" text.
struct SignInTitle: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Spoti\nfriends")
                    .font(.system(size: 60, weight: .heavy))
                    .padding(.bottom, 4)
                    .foregroundColor(Color.PresetColour.whitePrimary)
                Group {
                    Text("Listen ").foregroundColor(Color.PresetColour.whitePrimary) +
                    Text("together").foregroundColor(Color.PresetColour.spotifyGreen)
                }
                .font(.system(size: 22, weight: .regular))
            }
            Spacer()  // This is here to push the title and subtitle to the left
        }
        .padding()
        .padding(.top, 30)
    }
}

#Preview {
    UnauthenticatedView()
}
