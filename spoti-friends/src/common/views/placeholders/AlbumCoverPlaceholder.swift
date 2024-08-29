import SwiftUI

/// Renders the placeholder view for an album cover.
struct AlbumCoverPlaceholder: View {
    var body: some View {
        ImageWithSpecs(imageUrl: AlbumMock.sour.image, width: 36, height: 36, cornerRadius: 2)
            .redacted(reason: .placeholder)
            .animatePlaceholder()
    }
}

#Preview {
    AlbumCoverPlaceholder()
}
