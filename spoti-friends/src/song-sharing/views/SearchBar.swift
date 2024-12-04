//import SwiftUI
//
//struct SearchBar: View {
//    var placeholderText: String
//    
//    var body: some View {
//        HStack {
//            Text(placeholderText)
//                .font(.callout)
//                .foregroundStyle(Color.PresetColour.blackSecondary)
//                .padding(.vertical, 12)
//                .padding(.horizontal, 32)
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .background(Color.PresetColour.whitePrimary)
//                .cornerRadius(8)
//                .overlay(
//                    HStack {
//                        Image(systemName: "magnifyingglass")
//                            .foregroundColor(Color.PresetColour.blackSecondary)
//                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
//                            .padding(.leading, 8)
//                    }
//                )
//        }
//        .frame(maxWidth: .infinity)
//        .padding(.horizontal, 10)
//        .contentShape(Rectangle())
//    }
//}
//
//
//#Preview {
//    SearchBar(placeholderText: "Search...")
//}

import SwiftUI

struct SearchBar: View {
    var placeholderText: String
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            TextField(placeholderText, text: $searchText)
                .font(.callout)
                .foregroundStyle(Color.PresetColour.blackSecondary)
                .padding(.vertical, 12)
                .padding(.horizontal, 32)
                .background(Color.PresetColour.whitePrimary)
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color.PresetColour.blackSecondary)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        if !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 10)
        .contentShape(Rectangle())
    }
}

#Preview {
    @Previewable @State var searchText = ""
    
    return SearchBar(placeholderText: "Search...", searchText: $searchText)
}
