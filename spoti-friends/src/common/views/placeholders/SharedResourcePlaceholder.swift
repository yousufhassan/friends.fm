import SwiftUI

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
