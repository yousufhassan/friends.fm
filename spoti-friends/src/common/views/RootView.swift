import SwiftUI
import RealmSwift

/// The view that is rendered when the app opens, depending on the user's authorization status.
///
/// If the user granted authorization, render the `FriendActivityView`.
///
/// If the user denied authorization, render the `DeniedView`.
///
/// If the user has not completed authorization, render the `SignInView`.
struct RootView: View {
    @EnvironmentObject private var authorizationViewModel: AuthorizationViewModel
//    @StateObject private var friendActivityViewModel: FriendActivityViewModel
    @State private var authorizationStatus: AuthorizationStatus = .unauthenticated
    
    var body: some View {
        // Navigate to the appropriate view depending on the user's authorization status
        NavigationStack {
            switch authorizationStatus {
            case .unauthenticated:
                UnauthenticatedView()
            case .granted:
                AuthenticatedView()
                    .environmentObject(authorizationViewModel)
            case .denied:
                AuthorizationDeniedView()
            }
        }
        // The onReceive is called when the `authorizationViewModel.authorizationStatus` variable
        // is changed.
        .onReceive(authorizationViewModel.$authorizationStatus, perform: { _ in
            self.authorizationStatus = self.authorizationViewModel.authorizationStatus
        })
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView().environmentObject(AuthorizationViewModel())
    }
}
