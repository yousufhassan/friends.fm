import SwiftUI

/// A  view that displays a list of sent songs grouped by shared timestamp.
/// If the song was sent to a single recipient, then render it alone. If it was sent to multiple, render them as one item
/// and stack the profile images together.
struct SentSongsTab: View {
    @EnvironmentObject var shareViewModel: ShareViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(groupedResources(sentResources: shareViewModel.sentResources), id: \.0) { key, resources in
                    SentResourceView(
                        resource: resources.first!,
                        receivers: resources.map { $0.getReceiver() }
                    )
                }
                
            }
            .padding(.leading)
        }
    }
}

/// Groups the given `SharedResource` objects by their shared timestamp (`sharedTs`) and returns the results sorted in descending order.
/// This allows us to group resources shared to multiple receivers as one action together.
///
/// - Parameter sentResources: An array of `SharedResource` objects to group and sort.
/// - Returns: An array of tuples where each tuple contains:
///   - An `Int` representing the shared timestamp (`sharedTs`) used as the grouping key.
///   - An array of `SharedResource` objects that share the same `sharedTs` value.
///
/// The results are sorted in descending order based on the `sharedTs` key.
private func groupedResources(sentResources: [SharedResource]) -> [(Int, [SharedResource])] {
    let grouped = Dictionary(grouping: sentResources) { resource in
        Int(resource.getSharedTs())
    }
    return grouped.sorted(by: { $0.key > $1.key })
}

#Preview {
    SentSongsTab()
        .environmentObject(ShareViewModel(user: UserMock.userJimHalpert, sentResources: SharedResourceMock.sentResources))
        
}
