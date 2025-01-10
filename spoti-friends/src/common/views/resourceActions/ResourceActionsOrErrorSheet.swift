import SwiftUI

/// View that displays an sheet with resource actions or an error based on the provided state.
///
/// `ResourceActionsOrErrorSheet` dynamically renders a sheet depending on the `ActiveSheet` state.
/// It supports actions for Spotify resources or displays error-specific sheets.
///
/// - Parameters:
///   - resource: An optional `SpotifyResource` object representing the Spotify resource for actions.
///   - sharedResource: An optional `SharedResource` object if the resource is shared.
///   - shareViewModel: An optional `ShareViewModel` instance for managing shared resource actions.
///   - showSheet: A binding to control the visibility of the sheet.
///   - sheet: A binding to determine the currently active sheet type (`actions` or `error`).
///
/// - Note: `sharedResource` and `shareViewModel` are optionally passed in so that we can handle actions on those
///          types of resources. The caller will not pass it if it is not a `SharedResource`.
struct ResourceActionsOrErrorSheet: View {
    var resource: SpotifyResource?
    var sharedResource: SharedResource?
    var shareViewModel: ShareViewModel?
    @Binding var showSheet: Bool
    @Binding var sheet: ActiveSheet
    
    init(resource: SpotifyResource?, sharedResource: SharedResource? = nil, shareViewModel: ShareViewModel? = nil,
         showSheet: Binding<Bool>, sheet: Binding<ActiveSheet>) {
        self.resource = resource
        self.sharedResource = sharedResource
        self.shareViewModel = shareViewModel
        self._showSheet = showSheet
        self._sheet = sheet
    }
    
    var body: some View {
        switch sheet {
        case .actions:
            if let spotifyResource = resource,
               let user = PersistedStorage.shared.getSignedInUser() {
                ResourceActionsSheet(
                    resource: spotifyResource,
                    actions: ResourceActionType
                        .determineActions(showSheet: $showSheet,
                                          resource: spotifyResource,
                                          sharedResource: sharedResource,
                                          shareViewModel: shareViewModel,
                                          user: user) { error in
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
