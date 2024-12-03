import SwiftUI

struct SongShareView: View {
    let searchBarPlaceholderText = "What song do you want to share?"
    
    var body: some View {
        VStack {
            PageTitle(pageTitle: "Share")
            
            // Search bar
            SearchBar(placeholderText: searchBarPlaceholderText)
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.PresetColour.darkgrey)
    }
}

#Preview {
    SongShareView()
}
