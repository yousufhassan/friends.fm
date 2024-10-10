import SwiftUI

/// The view that renders the sign in button in the `SignInView`.
struct SignInButton: View {
    @EnvironmentObject var authorizationViewModel: AuthorizationViewModel
    @Binding var showWebView: Bool
    @Binding var responseUrl: URL?
    let buttonLabel: String = "Sign in with Spotify"
    
    var body: some View {
        Button(buttonLabel) {
            // On button click, show the authorizationWebView
            showWebView = true
        }
        .padding()
        .frame(width: 234)
        .background(Color.PresetColour.spotifyGreen)
        .foregroundColor(Color.PresetColour.whitePrimary)
        .cornerRadius(30)
        .sheet(isPresented: $showWebView) {
            NavigationStack {
                let userAuthorizationUrl = authorizationViewModel.getUserAuthorizationUrl()
                AuthorizationWebView(
                    url: userAuthorizationUrl,
                    showWebView: $showWebView,
                    responseUrl: $responseUrl
                )
                .ignoresSafeArea()
            }
        }
        .onChange(of: responseUrl) {
            if let url = responseUrl {
                Task {
                    await authorizationViewModel.handleRedirectBackToApp(url)
                }
            }
        }
    }
}

//#Preview {
//    SignInButton()
//}
