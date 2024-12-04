import SwiftUI

// TODO: Add docs
struct SongSearchView: View {
    let searchBarPlaceholderText: String
    @Binding var isSearching: Bool
    @State private var searchText = ""
    
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
    SongSearchView(searchBarPlaceholderText: "Search...", isSearching: $isSearching)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.PresetColour.darkgrey)
}
