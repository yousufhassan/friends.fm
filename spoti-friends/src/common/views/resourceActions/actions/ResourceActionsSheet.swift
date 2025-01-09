import SwiftUI

/// A  View presenting a sheet with actions related to a Spotify resource.
/// It displays a preview of the resource at the top, followed by a list of actions that can be taken.
///
/// - Parameters:
///   - resource: The `SpotifyResource` object being acted upon.
///   - actions: An array of `ResourceActionType` defining the available actions for the resource.
///   
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
    let sharedResource = SharedResourceMock.resource1
    let actions: [ResourceActionType] = ResourceActionType
        .determineActions(showSheet: $showSheet,
                          resource: sharedResource.getResource()!,
                          sharedResource: sharedResource,
                          shareViewModel: ShareViewModel(user: UserMock.userJimHalpert),
                          user: UserMock.userJimHalpert) { _ in
        showSheet = false
    }
    
    Button("Open sheet") {
        showSheet = true
    }
    .sheet(isPresented: $showSheet) {
        ResourceActionsSheet(resource: sharedResource.getResource()!, actions: actions)
    }
}
