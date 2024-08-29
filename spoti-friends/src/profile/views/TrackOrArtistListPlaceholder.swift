import SwiftUI


/// A SwiftUI view that provides a placeholder View for a list of tracks or artists.
///
/// This view is typically used as a skeleton placeholder while data is being
/// loaded or fetched from an external source.
struct TrackOrArtistListPlaceholder: View {
    var body: some View {
        VStack (alignment: .leading) {
            ForEach(0..<3) {index in
                HStack {
                    AlbumCoverPlaceholder()
                    
                    VStack (alignment: .leading) {
                        TextPlaceholder(size: index % 2 == 0 ? .medium : .large)
                        TextPlaceholder(size: .small)
                    }
                }
            }
        }
    }
}

#Preview {
    TrackOrArtistListPlaceholder()
}
