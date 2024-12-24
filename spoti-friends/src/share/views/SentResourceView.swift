import SwiftUI

/// A view that displays a sent shared resource, including the resource details and the receiver's profile image.
///
/// This view represents a horizontal layout where the shared resource is displayed on the left,
/// and the receiver's profile image is shown on the right.
///
/// - Parameters:
///   - resource: A `SharedResource` object representing the resource that was shared.
///               It determines the type of resource and displays the appropriate view based on it.
struct SentResourceView: View {
    let resource: SharedResource
    var body: some View {
        HStack {
            if (resource.getType() == .track) {
                TrackView(track: resource.getResource() as! Track)
            }
            
            Spacer()
            ProfileImage(profile: resource.getReceiver(), width: 24, height: 24)
        }
    }
}

#Preview {
    let sender = UserMock.userJimHalpert
    let receiver = SpotifyProfileMock.michaelScott
    let resource = SharedResource(resource: TrackMock.iRememberEverything, sender: sender, receiver: receiver)
    SentResourceView(resource: resource)
}
