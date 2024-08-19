import SwiftUI

/// The view that is rendered when the Spotify authorization for the user failed or they denied.
struct AuthorizationDeniedView: View {
    @EnvironmentObject var userViewModel: AuthorizationViewModel
    
    var body: some View {
        VStack {
            Spacer()
            
            // Error page title
            Text("Permissions Needed")
                .foregroundStyle(Color.PresetColour.whitePrimary)
                .font(.title)
                .fontWeight(.bold)
            
            // Error icon image
            Image(.redXError)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 180)
                .padding(.top, 16)
                .padding(.bottom, 32)
            
            // Explanation text
            Group {
                Text("We're sorry, but we need certain permissions to provide the full app experience.")
                    .padding(.bottom, 16)
                Text("To enjoy the full functionality of our app, please grant the required permissions.")
            }
            .foregroundStyle(Color.PresetColour.whitePrimary)
            .multilineTextAlignment(.center)
            
            // Back to sign in button
            Spacer()
            BackToSignInButton()
            Spacer()
            
        }
        .padding()
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
        .background(backgroundGradient)
    }
}

/// The view that renders the back to sign in button.
struct BackToSignInButton: View {
    @EnvironmentObject var userViewModel: AuthorizationViewModel
    
    var body: some View {
        let buttonLabel = "Back to sign in"
        
        Button(buttonLabel) {
            userViewModel.authorizationStatus = .unauthenticated
        }
        .padding()
        .frame(width: 234)
        .background(Color.PresetColour.spotifyGreen)
        .foregroundColor(Color.PresetColour.whitePrimary)
        .cornerRadius(30)
    }
}

#Preview {
    AuthorizationDeniedView()
}
