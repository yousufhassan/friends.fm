import SwiftUI

/// A SwiftUI view that provides a placeholder View for a SharedResource item.
struct SharedResourcePlaceholder: View {
    var body: some View {
        HStack {
            TrackOrArtistViewPlaceholder()
            Spacer()
            ProfileImage(profile: SpotifyProfileMock.dwightSchrute, width: 24, height: 24)
                .redacted(reason: .placeholder)
                .animatePlaceholder()
                .padding(.bottom, 6)
        }
    }
}

/// A SwiftUI view that provides a placeholder View for a list of SharedResource items
struct SharedResourceListPlaceholder: View {
    var body: some View {
        VStack (alignment: .leading) {
            ForEach(0..<3) {index in
                SharedResourcePlaceholder()
            }
        }
    }
}

#Preview {
    SharedResourceListPlaceholder()
}
