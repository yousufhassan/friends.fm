import SwiftUI

/// The View that renders a profile image for the passed in profile
///
/// If the user does not have a profile image, then a generic image will be used with the first letter of their display name.
///
/// - Parameters:
///   - profile: The profile to return the image for.
///   - width: The profile image width.
///   - height: The profile image height.
///
/// - Returns: A View for the profile image.
struct ProfileImage: View {
    let profile: SpotifyProfile
    let width, height: CGFloat
    @State private var profileImage: UIImage? = nil
    
    var body: some View {
        Group {
            if let profileImage = profileImage {
                Image(uiImage: profileImage)
                    .resizable()
                
            } else {
                Text(profile.displayName.prefix(1).capitalized)
                    .font(.system(size: width / 2))
                    .frame(width: width, height: height)
                    .foregroundColor(Color.PresetColour.whitePrimary)
                    .background(Color.PresetColour.generateDarkColour(from: profile.spotifyId))
            }
        }
        .aspectRatio(contentMode: .fill)
        .frame(width: width, height: height)
        .clipShape(Circle())
        .onAppear {
            profileImage = getProfilePictureFromDisk(imageName: profile.spotifyId)
        }
    }
}

#Preview {
    ZStack {
        let profile = SpotifyProfileMock.jimHalpert
        ProfileImage(profile: profile, width: 80, height: 80)
    }
}
