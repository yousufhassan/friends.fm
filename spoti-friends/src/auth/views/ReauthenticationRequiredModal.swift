import SwiftUI

/// A modal view that informs the user that reauthentication is required, typically when new scopes are required.
struct ReauthenticationRequiredModal: View {
    @EnvironmentObject var authorizationViewModel: AuthorizationViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            Group {
                Text("Reauthentication Required")
                    .font(.title2)
                    .bold()
                
                Text("You need to log out and sign in again to continue using the app.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .foregroundStyle(Color.PresetColour.whitePrimary)
            
            LogoutButton()
                .padding(.top)
                .environmentObject(authorizationViewModel)
        }
        .padding(.vertical, 30)
        .padding(.horizontal, 20)
        .background(Color.PresetColour.darkgrey)
        .cornerRadius(20)
        .shadow(radius: 10)
        .frame(maxWidth: 400)
        .padding(.horizontal, 40)
    }
}

#Preview {
    VStack {
        ReauthenticationRequiredModal()
            .environmentObject(AuthorizationViewModel())
    }
}
