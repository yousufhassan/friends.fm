import SwiftUI

/// A SwiftUI view that provides a placeholder View for a track or artist item.
///
/// - Parameter index: If used in a list context, the index of this placeholder, for alternating sizes.
///
/// This view is typically used as a skeleton placeholder while data is being
/// loaded or fetched from an external source.
struct TrackOrArtistViewPlaceholder: View {
    let index: Int
    
    init(index: Int = 1) {
        self.index = index
    }
    
    var body: some View {
        HStack {
            AlbumCoverPlaceholder()
            
            VStack (alignment: .leading) {
                TextPlaceholder(size: index % 2 == 0 ? .medium : .large)
                TextPlaceholder(size: .small)
            }
        }
    }
}

/// A SwiftUI view that provides a placeholder View for a list of tracks or artists.
///
/// This view is typically used as a skeleton placeholder while data is being
/// loaded or fetched from an external source.
struct TrackOrArtistListPlaceholder: View {
    var body: some View {
        VStack (alignment: .leading) {
            ForEach(0..<3) {index in
                TrackOrArtistViewPlaceholder(index: index)
            }
        }
    }
}

#Preview {
    TrackOrArtistListPlaceholder()
}
