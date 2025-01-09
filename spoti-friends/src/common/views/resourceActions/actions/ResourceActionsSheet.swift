import SwiftUI

struct ResourceActionsSheet: View {
    let resource: SpotifyResource
    let actions: [ResourceActionType]
    
    var body: some View {
        VStack {
            // Preview of resource
            SpotifyResourceView(resource: resource) {
                () // Overriding the onTapGesture to do nothing
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            
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
    let actions: [ResourceActionType] = ResourceActionType.receivedResourceActions(resource: resource, user: UserMock.userJimHalpert) { _ in
        showSheet = false
    }
    
    Button("Open sheet") {
        showSheet = true
    }
    .sheet(isPresented: $showSheet) {
        ResourceActionsSheet(resource: resource, actions: actions)
    }
}
