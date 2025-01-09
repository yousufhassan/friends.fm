import SwiftUI

// TODO: Add docs
struct ResourceActionsOrErrorSheet: View {
    let resource: SpotifyResource?
    @State var sheet: ActiveSheet?
    
    var body: some View {
        switch sheet {
        case .actions:
            if let spotifyResource = resource,
               let user = PersistedStorage.shared.getSignedInUser() {
                ResourceActionsSheet(
                    resource: spotifyResource,
                    actions: ResourceActionType.receivedResourceActions(
                        resource: spotifyResource,
                        user: user
                    ) { error in
                        DispatchQueue.main.async {
                            self.sheet = .error(error)
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
            
        case .none:
            Text("Hmm, nothing.")
        }
    }
}

#Preview {
    let track = TrackMock.iRememberEverything
    
    ResourceActionsOrErrorSheet(resource: track, sheet: ActiveSheet.actions)
        .environmentObject(ShareViewModel(user: UserMock.userJimHalpert))
}

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
