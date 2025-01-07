import SwiftUI

struct ResourceActionsSheet: View {
    let resource: SpotifyResource
    
    var body: some View {
        VStack {
            // Preview of resource
            if (resource is Track) {
                TrackView(track: resource as! Track) {
                    () // Overriding the onTapGesture to do nothing
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
            
            Divider()
            
            // Actions
            VStack {
                ResourceAction(icon: Image(.spotifyIconGreen),
                               label: "Open in Spotify",
                               action: {
                    if let url = URL(string: resource.getSpotifyUri()) {
                        UIApplication.shared.open(url)
                    }
                })
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top)
        .presentationDetents([.medium, .large])
    }
}

#Preview {
    @Previewable @State var showSheet = true
    let resource = TrackMock.iRememberEverything
    
    Button("Open sheet") {
        showSheet = true
    }
    .sheet(isPresented: $showSheet) {
        ResourceActionsSheet(resource: resource)
    }
}
