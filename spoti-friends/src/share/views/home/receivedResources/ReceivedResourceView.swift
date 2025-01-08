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
    @State private var activeSheet: ActiveSheet?
    @State private var addToQueueError: AddToQueueError?
    
    enum ActiveSheet: Identifiable {
        case actions, error(AddToQueueError)
        
        var id: String {
            switch self {
            case .actions:
                return "actions"
            case .error:
                return "error"
            }
        }
    }
    
    var body: some View {
        HStack {
            SpotifyResourceView(resource: resource.getResource()) {
                activeSheet = .actions
            }
            
            Spacer()
            ProfileImage(profile: resource.getSender(), width: 24, height: 24)
        }
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
            case .actions:
                if let spotifyResource = resource.getResource(),
                   let signedInUser = shareViewModel.user {
                    ResourceActionsSheet(
                        resource: spotifyResource,
                        actions: ResourceActionType.receivedResourceActions(
                            resource: spotifyResource,
                            user: signedInUser
                        ) { error in
                            DispatchQueue.main.async {
                                self.activeSheet = .error(error)
                            }
                        }
                    )
                } else {
                    Text("Oops! Something went wrong...")
                }
                
            case .error(let error):
                VStack {
                    switch error {
                    case .noActiveDevice:
                        NoActiveDeviceErrorSheet()
                    case .premiumRequired:
                        PremiumRequiredErrorSheet()
                    case .unknown:
                        Text("Something went wrong")
                    }
                }
                .presentationDetents([.fraction(0.3)])
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
