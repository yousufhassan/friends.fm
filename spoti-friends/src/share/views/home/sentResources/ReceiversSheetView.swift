import SwiftUI

/// Sheet view that displays the receivers of a shared resource.
///
/// This view consists of:
/// - A preview of the shared resource if it is a track, rendered using the `TrackView`.
/// - A scrollable list of receivers, each displayed with their profile image and display name.
///
/// - Parameters:
///   - `resource`: The `SharedResource` being shared, used to determine the resource type and display a preview if it's a track.
///   - `receivers`: An array of `SpotifyProfile` objects representing the receivers of the shared resource.
struct ReceiversSheetView: View {
    let resource: SharedResource
    let receivers: [SpotifyProfile]
    
    var body: some View {
        VStack {
            Text("Sent to")
                .foregroundStyle(Color.PresetColour.whitePrimary)
                .bold()
            
            // Preview of track to send
            if (resource.getType() == .track) {
                TrackView(track: resource.getResource() as! Track) {
                    ()
                }
                .padding(.horizontal)
            }

            Divider()
            
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16) { // Add spacing between list items
                    ForEach(receivers, id: \.id) { receiver in
                        HStack {
                            // Display receiver's profile image if available
                            ProfileImage(profile: receiver, width: 28, height: 28)
                            
                            // Display receiver's display name
                            Text(receiver.getDisplayName())
                                .foregroundStyle(Color.PresetColour.whitePrimary)
                                .font(.callout)
                                .padding(.leading, 8)
                        }
                    }
                }
                .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top)
        .presentationDetents([.fraction(0.4), .large])
    }
}


#Preview {
    @Previewable @State var showSheet = true
    let receivers = SpotifyProfileMock.allProfiles
    let resource = SharedResourceMock.resource1
    
    Button("Open sheet") {
        showSheet = true
    }
    .sheet(isPresented: $showSheet) {
        ReceiversSheetView(resource: resource, receivers: receivers)
    }
}
