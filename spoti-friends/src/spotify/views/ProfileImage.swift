import SwiftUI

/// The View that renders a profile image.
///
/// - Parameters:
///   - imageName: The name which the image is stored as (will be the user's Spotify ID).
///   - width: The profile image width.
///   - height: The profile image height.
///
/// - Returns: A View for the profile image.
struct ProfileImage: View {
    let imageName: String
    let width, height: CGFloat
    @State private var profileImage: UIImage? = nil
    @EnvironmentObject var friendActivityViewModel: FriendActivityViewModel
    
    var body: some View {
        Group {
            if let profileImage = profileImage {
                Image(uiImage: profileImage)
                    .resizable()
         
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
            }
        }
        .aspectRatio(contentMode: .fill)
        .frame(width: width, height: height)
        .clipShape(Circle())
        .onAppear {
            profileImage = getProfilePictureFromDisk(imageName: imageName)
        }
    }
}

#Preview {
    ZStack {
        let user = UserMock.userJimHalpert
        ProfileImage(imageName: "", width: 80, height: 80)
            .environmentObject(FriendActivityViewModel(user: user, friendActivites: []))
    }
}
