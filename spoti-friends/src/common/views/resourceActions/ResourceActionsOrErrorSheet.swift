import SwiftUI

// TODO: Add docs
struct ResourceActionsOrErrorSheet: View {
    let resource: SpotifyResource?
    @Binding var showSheet: Bool
    @Binding var sheet: ActiveSheet
    
    var body: some View {
        switch sheet {
        case .actions:
            if let spotifyResource = resource,
               let user = PersistedStorage.shared.getSignedInUser() {
                ResourceActionsSheet(
                    resource: spotifyResource,
                    actions: ResourceActionType.receivedResourceActions(
                        showSheet: $showSheet,
                        resource: spotifyResource,
                        user: user
                    ) { error in
                        DispatchQueue.main.async {
                            self.showSheet = false
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            self.sheet = .error(error)
                            self.showSheet = true
                        }
                    }
                )
            } else {
                GenericErrorSheet()
            }
            
        case .error(let error):
            VStack {
                switch error {
                case .noActiveDevice:
                    NoActiveDeviceErrorSheet()
                case .premiumRequired:
                    PremiumRequiredErrorSheet()
                case .unknown:
                    GenericErrorSheet()
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var showSheet = true
    @Previewable @State var sheet: ActiveSheet = .actions
    let _ = PersistedStorage.shared.persistUser(UserMock.userJimHalpert)
    let track = TrackMock.iRememberEverything
    
    ResourceActionsOrErrorSheet(resource: track, showSheet: $showSheet, sheet: $sheet)
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
