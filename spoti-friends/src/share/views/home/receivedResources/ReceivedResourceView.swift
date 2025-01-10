import SwiftUI

/// A view that displays a received shared resource, including the resource details and the sender's profile image.
///
/// This view represents a horizontal layout where the shared resource is displayed on the left,
/// and the sender's profile image is shown on the right.
///
/// - Parameters:
///   - resource: A `SharedResource` object representing the resource that was received.
///               It determines the type of resource and displays the appropriate view based on it.
struct ReceivedResourceView: View {
    let resource: SharedResource
    @EnvironmentObject var shareViewModel: ShareViewModel
    
    var body: some View {
        HStack {
            SpotifyResourceView(resource: resource.getResource(), sharedResource: resource, shareViewModel: shareViewModel)
            
            Spacer()
            ProfileImage(profile: resource.getSender(), width: 24, height: 24)
        }
    }
}

#Preview {
    let _ = PersistedStorage.shared.persistUser(UserMock.userJimHalpert)
    
    let sender = SpotifyProfileMock.jimHalpert
    let receiver = SpotifyProfileMock.michaelScott
    let resource = SharedResource(resource: TrackMock.iRememberEverything, sender: sender, receiver: receiver)
    ReceivedResourceView(resource: resource)
        .environmentObject(ShareViewModel(user: UserMock.userJimHalpert))
}
