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
    @State private var showActions: Bool = false
    
    var body: some View {
        HStack {
            if (resource.getType() == .track) {
                let track = resource.getResource() as! Track
                TrackView(track: track) {
                    showActions = true
                }
            }
            
            Spacer()
            ProfileImage(profile: resource.getSender(), width: 24, height: 24)
        }
        .presentationDetents([.medium])
        .sheet(isPresented: $showActions) {
            if let spotifyResource = resource.getResource() {
                ResourceActionsSheet(resource: spotifyResource)
            } else {
                // TODO: Error view
                Text("Oops! Something went wrong...")
            }
        }
    }
}

#Preview {
    let sender = SpotifyProfileMock.jimHalpert
    let receiver = SpotifyProfileMock.michaelScott
    let resource = SharedResource(resource: TrackMock.iRememberEverything, sender: sender, receiver: receiver)
    ReceivedResourceView(resource: resource)
        .environmentObject(ShareViewModel(user: UserMock.userJimHalpert))
}
