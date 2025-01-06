import SwiftUI

/// A SwiftUI view for displaying the profile of a user who has not yet joined the app.
///
/// The `NonUserProfileView` presents basic profile details of a non-user and includes
/// a message encouraging the current user to invite them to join the app.
///
/// - Parameters:
///   - profile: The Spotify profile to display.
///
struct NonUserProfileView: View {
    let profile: SpotifyProfile
    
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @State private var isShareSheetPresented = false
    
    var body: some View {
        VStack {
            // Profile Details
            ProfileDetails(profile: profile)
                .environmentObject(profileViewModel)
            
            Spacer()
                .frame(height: 70)
            
            VStack {
                Text("\(profile.getDisplayName()) has not joined the app yet.")
                Text("Invite them to be part of the fun!")
                
                // Invite button
                Button(action: {
                    MetricsServiceManager.shared.trackInivtedUser(viewContext: .nonUserProfileView, users: [profile])
                    isShareSheetPresented = true
                }) {
                    Text("Invite \(profile.getDisplayName())")
                        .font(.headline)
                        .foregroundColor(Color.PresetColour.whitePrimary)
                        .padding()
                        .frame(width: 280, height: 48)
                        .background(Color.PresetColour.spotifyGreen)
                        .cornerRadius(100)
                }
                .sheet(isPresented: $isShareSheetPresented) {
                    ActivityViewController(activityItems: ["I'm using friends.fm, join the fun here: https://friendsfm.super.site/"])
                        .presentationDetents([.medium, .large])
                }
                
            }
            .padding(.vertical)
            .foregroundStyle(Color.PresetColour.whitePrimary)
            
            Spacer()
        }
        .padding(.top)
        .padding(.horizontal, 20)
    }
}

#Preview {
    let user = UserMock.userJimHalpert
    
    NonUserProfileView(profile: user.spotifyProfile)
        .environmentObject(ProfileViewModel(user: user))
        .background(Color.PresetGradient.profileViewGradient(profile: user.spotifyProfile))
}
