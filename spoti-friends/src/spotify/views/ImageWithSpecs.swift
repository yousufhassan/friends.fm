import SwiftUI

/// The View that renders an image with the given specifications.
///
/// - Parameters:
///   - album: The album whose cover to display.
///   - width: The album cover image width.
///   - height: The album cover image height.
///   - cornerRadius: The corner radius for the image (optional).
///
/// - Returns: A View for the album cover image.
struct ImageWithSpecs: View {
    let imageUrl: URL?
    let width, height: CGFloat
    var cornerRadius: CGFloat
    
    init(imageUrl: String, width: CGFloat, height: CGFloat, cornerRadius: CGFloat = 12) {
        self.imageUrl = URL(string: imageUrl)
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
    }
    
    var body: some View {
        AsyncImage(url: imageUrl) { phase in
            switch phase {
            case .empty:
                ProgressView() // Shows a progress indicator while loading
            case .success(let image):
                image
                    .resizable()
            case .failure:
                Image(systemName: "person.circle.fill")
                    .resizable()
            @unknown default:
                EmptyView()
            }
        }
        .aspectRatio(contentMode: .fill)
        .frame(width: width, height: height)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

#Preview {
    ZStack {
        let url = AlbumMock.theDefinition.image
        ImageWithSpecs(imageUrl: url, width: 300, height: 300)
    }
}
