import SwiftUI

/// A view that displays a sent shared resource, including the resource details and the receiver(s) profile image(s).
///
/// This view represents a horizontal layout where the shared resource is displayed on the left,
/// and the receiver's profile image is shown on the right. If there are multuple receivers, stack and offset the images.
///
/// - Parameters:
///   - resource: A `SharedResource` object representing the resource that was shared.
///               It determines the type of resource and displays the appropriate view based on it.
///   - receivers: An array of `SpotifyProfiles` who were the recipient of this resource.
struct SentResourceView: View {
    let resource: SharedResource
    let receivers: [SpotifyProfile]
    @State var displayReceiversSheet = false
    
    var body: some View {
        HStack {
            if (resource.getType() == .track) {
                TrackView(track: resource.getResource() as! Track)
            }
            
            Spacer()
            ZStack {
                ForEach(Array(receivers.prefix(3).enumerated()), id: \.1.id) { index, profile in
                    ProfileImage(profile: profile, width: 24, height: 24)
                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                        .offset(x: CGFloat(index * 4), y: CGFloat(-index * 4)) // Top-right overlap
                        .zIndex(-Double(index)) // Ensure earlier items are behind
                }
            }
            .padding(.trailing)
            .onTapGesture {
                displayReceiversSheet = true
            }
        }
        .sheet(isPresented: $displayReceiversSheet) {
            ReceiversSheetView(resource: resource, receivers: receivers)
        }
    }
}

#Preview {
    let sender = SpotifyProfileMock.jimHalpert
    let receivers = [SpotifyProfileMock.michaelScott, SpotifyProfileMock.dwightSchrute]
    let resource = SharedResource(resource: TrackMock.iRememberEverything, sender: sender, receiver: receivers[0])
    SentResourceView(resource: resource, receivers: receivers)
}
