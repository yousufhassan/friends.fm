import SwiftUI

struct SearchView: View {
    let searchBarPlaceholderText: String
    @State private var searchText = ""
    
    var body: some View {
            VStack {
                DecorativeSearchBar(placeholderText: searchBarPlaceholderText)
                Text("Hello!")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.PresetColour.darkgrey)
            .searchable(text: $searchText, prompt: searchBarPlaceholderText)
        
    }
}


#Preview {
    SearchView(searchBarPlaceholderText: "Search...")
}
