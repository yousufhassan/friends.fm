import SwiftUI

/// A  view that displays a list of received songs.
struct ReceivedResourcesTab: View {
    @EnvironmentObject var shareViewModel: ShareViewModel
    
    var body: some View {
        if !(shareViewModel.hasFetchedReceivedResources) {
            VStack {
                HStack {
                    SharedResourceListPlaceholder()
                    Spacer()
                }
                Spacer()
            }
        } else if (shareViewModel.receivedResources.isEmpty) {
            ReceivedResourcesEmptyView()
        } else {
            ScrollView {
                LazyVStack {
                    ForEach(shareViewModel.receivedResources) { resource in
                        ReceivedResourceView(resource: resource)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    let receivedResources: [SharedResource] = SharedResourceMock.receivedResources
    
    ReceivedResourcesTab()
        .environmentObject(ShareViewModel(user: UserMock.userJimHalpert,
                                          receivedResources: receivedResources))
    
}

/// The view to display when there are no received resources for the user.
struct ReceivedResourcesEmptyView: View {
    @State private var isShareSheetPresented = false
    
    var body: some View {
        VStack {
            VStack (spacing: 6) {
                Text("Things are looking quiet...")
                Text("Invite some friends to get the party started!")
            }
            .foregroundStyle(Color.PresetColour.whiteSecondary)
            .font(.callout)
            .padding(.top, 24)
            .padding(.bottom, 24)
            
            // Invite button
            Button(action: {
                MetricsServiceManager.shared.trackInivtedUser(viewContext: .receivedResourcesTab)
                isShareSheetPresented = true
            }) {
                Text("Invite")
                    .font(.headline)
                    .foregroundColor(Color.PresetColour.whitePrimary)
                    .padding()
                    .frame(width: 96, height: 36)
                    .background(Color.PresetColour.spotifyGreen)
                    .cornerRadius(100)
            }
            .sheet(isPresented: $isShareSheetPresented) {
                ActivityViewController(activityItems: ["I'm using friends.fm, join the fun here: https://friendsfm.super.site/"])
                    .presentationDetents([.medium, .large])
            }
            
            Spacer()
        }
    }
}
