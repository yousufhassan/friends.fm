import SwiftUI

struct SearchView: View {
    let searchBarPlaceholderText: String
    @State private var searchText = ""
    @Binding var isSearching: Bool
    
    var body: some View {
        VStack {
            HStack {
                SearchBar(placeholderText: searchBarPlaceholderText, searchText: $searchText)
                Button(action: {
                    withAnimation(.easeOut(duration: 0.2)) {
                        self.isSearching = false
                    }
                    
                }) {
                    Text("Cancel")
                        .font(.footnote)
                }
            }
            
            Spacer()
            
        }
        .padding()
        .searchable(text: $searchText, prompt: searchBarPlaceholderText)
        
    }
}


#Preview {
    @Previewable @State var isSearching: Bool = true
    SearchView(searchBarPlaceholderText: "Search...", isSearching: $isSearching)
}
