import SwiftUI

/// A View that allows users to share songs with their friends.
///
/// The view contains a search bar to search for songs to share and two scrollable tabs to display
/// songs received from friends and songs sent to friends.
///
/// - Parameters:
///   - searchBarPlaceholderText: The placeholder text for the search bar.
///   - isSearching: A boolean denoting whether or not the search bar is focused (true) or unfocused (false).
///
struct SongShareHomeView: View {
    @EnvironmentObject var shareViewModel: ShareViewModel
    let searchBarPlaceholderText: String
    @Binding var isSearching: Bool
    @Binding var selectedTab: SongShareTab
    @State private var hasFetchedData = false
    
    init(searchBarPlaceholderText: String, isSearching: Binding<Bool>, selectedTab: Binding<SongShareTab>) {
        self.searchBarPlaceholderText = searchBarPlaceholderText
        self._isSearching = isSearching
        self._selectedTab = selectedTab
        
        
        // Picker background color
        UISegmentedControl.appearance().backgroundColor = UIColor(Color(red: 0.06, green: 0.06, blue: 0.06))
        
        // Picker background color of selected
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color(red: 0.11, green: 0.11, blue: 0.11))
        
        // Picker foreground color of selected
        UISegmentedControl.appearance().setTitleTextAttributes(
            [.foregroundColor: UIColor(Color.PresetColour.spotifyGreen)], for: .selected)
        
        // Picker foreground color of inactive
        UISegmentedControl.appearance().setTitleTextAttributes(
            [.foregroundColor: UIColor(Color.PresetColour.whitePrimary)], for: .normal)
    }
    
    var body: some View {
        VStack {
            // Page Title and Search Bar
            VStack {
                PageTitle(pageTitle: "Share")
                
                DecorativeSearchBar(placeholderText: searchBarPlaceholderText)
                    .onTapGesture {
                        withAnimation(.easeOut(duration: 0.2)) {
                            self.isSearching = true
                        }
                    }
            }
            .padding()
            
            // Received/Sent Tab Bar
            ZStack (alignment: .bottom) {
                Picker("Tabs", selection: $selectedTab) {
                    Text("Received").tag(SongShareTab.received)
                    Text("Sent").tag(SongShareTab.sent)
                }
                .pickerStyle(.segmented)
                
                Divider()
                    .frame(height: 1)
                    .background(Color.PresetColour.whitePrimary)
                    .opacity(0.8)
            }
            
            // Horizontal scrollable TabView
            TabView(selection: $selectedTab) {
                // Received songs tab
                ScrollView {
                    LazyVStack {
                        ForEach(shareViewModel.receivedResources) { resource in
                            ReceivedResourceView(resource: resource)
                        }
                    }
                    .padding(.horizontal)
                }
                .tag(SongShareTab.received)
                
                // Sent songs tab
                SentSongsTab()
                    .environmentObject(shareViewModel)
                    .tag(SongShareTab.sent)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .onAppear {
            if !hasFetchedData {
                Task {
                    await shareViewModel.fetchReceivedAndSentResources()
                }
                hasFetchedData = true
            }
        }
        .alert(shareViewModel.sharedToNonUserAlertText, isPresented: $shareViewModel.showSharedToNonUserAlert) {
            Button("Invite") {
                shareContent(message: "I sent you some songs on friends.fm! Join now to view them: https://friendsfm.super.site/")
                MetricsServiceManager.shared.trackInivtedUser(viewContext: .songShareHomeView)
            }
        }
    }
    
    /// Presents the system's share sheet to allow users to share the specified content.
    /// - Parameter message: The content to be shared. This could be text, a URL, or any other string-based content.
    private func shareContent(message: String) {
        let activityViewController = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        
        // Present the activity view controller
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(activityViewController, animated: true)
        }
    }
}

#Preview {
    @Previewable @State var isSearching = false
    @Previewable @State var selectedTab = SongShareTab.received
    let placeholderText = "What song do you want to share?"
    
    SongShareHomeView(searchBarPlaceholderText: placeholderText,
                      isSearching: $isSearching,
                      selectedTab: $selectedTab)
    .environmentObject(ShareViewModel(user: UserMock.userJimHalpert))
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.PresetColour.darkgrey)
}
