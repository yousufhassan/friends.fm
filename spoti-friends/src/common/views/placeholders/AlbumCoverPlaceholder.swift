import SwiftUI

/// Renders the placeholder view for an album cover.
struct AlbumCoverPlaceholder: View {
    var body: some View {
        AlbumCover(album: AlbumMock.sour, width: 36, height: 36, cornerRadius: 2)
            .redacted(reason: .placeholder)
            .animatePlaceholder()
    }
}

#Preview {
    AlbumCoverPlaceholder()
}
