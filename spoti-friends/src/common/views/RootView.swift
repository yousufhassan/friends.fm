import SwiftUI
import RealmSwift

/// The view that is rendered when the app opens, depending on the user's authorization status.
///
/// If the user has not completed authorization, render the `UnauthenticatedView`.
///
/// If the user granted authorization, render the `AuthenticatedView`.
///
/// If the user denied authorization, render the `AuthorizationDeniedView`.
struct RootView: View {
    @EnvironmentObject private var authorizationViewModel: AuthorizationViewModel
    @State private var authorizationStatus: AuthorizationStatus = .unauthenticated
    @State private var showErrorView: Bool = false
    
    var body: some View {
        // Navigate to the appropriate view depending on the user's authorization status
        NavigationStack {
            if (authorizationViewModel.isFetchingUser) {
                AppLoadingView()
            }
            else {
                VStack {
                    // Main content based on authorization status
                    switch authorizationStatus {
                    case .unauthenticated, .error:
                        UnauthenticatedView()
                    case .granted:
                        AuthenticatedView()
                            .environmentObject(authorizationViewModel)
                    case .denied:
                        AuthorizationDeniedView()
                    }
                }
                .navigationDestination(isPresented: $showErrorView) {
                    SomethingWentWrongView()
                }
            }
        }
        // The onReceive is called when the `authorizationViewModel.authorizationStatus` variable
        // is changed.
        .onReceive(authorizationViewModel.$authorizationStatus, perform: { newStatus in
            self.authorizationStatus = newStatus
            if newStatus == .error {
                self.showErrorView = true
            }
        })
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView().environmentObject(AuthorizationViewModel())
    }
}
