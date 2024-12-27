import SwiftUI

struct ReceiversSheetView: View {
    let receivers: [SpotifyProfile]
    let resource: SharedResource
    
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
        ReceiversSheetView(receivers: receivers, resource: resource)
    }
}
