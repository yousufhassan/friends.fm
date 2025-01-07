import SwiftUI

struct ResourceActionsSheet: View {
    let resource: SpotifyResource
    let actions: [ResourceActionType]
    
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
                ForEach(actions, id: \.label) { action in
                    ResourceAction(action: action)
                }
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
    let actions: [ResourceActionType] = [.openInSpotify(resource: resource)]
    
    Button("Open sheet") {
        showSheet = true
    }
    .sheet(isPresented: $showSheet) {
        ResourceActionsSheet(resource: resource, actions: actions)
    }
}
