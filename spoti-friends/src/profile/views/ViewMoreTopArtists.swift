import SwiftUI

/// A SwiftUI view that displays a user's top artists.
/// This view is part of a navigation stack and shows a scrollable list of artists.
///
/// - Parameters:
///   - profile: The Spotify Profile to show the data for.
///
struct ViewMoreTopArtists: View {
    let profile: SpotifyProfile
    @State private var topArtists: ProfileViewModel.ArtistsWithResponseMetadata
    @State private var selectedTimeRange: ProfileViewModel.TimeRange = .oneMonth
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    
    init(profile: SpotifyProfile, topArtists: [Artist] = []) {
        self.profile = profile
        self.topArtists = ProfileViewModel.ArtistsWithResponseMetadata(artists: topArtists)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Top Artists")
                    .foregroundStyle(Color.PresetColour.whitePrimary)
                    .font(.title2)
                
                HStack {
                    Spacer()
                    TimeRangeSelector(selectedTimeRange: $selectedTimeRange)
                    Spacer()
                }
                .padding(.vertical, 8)
                
                ArtistList(artists: topArtists.artists, showItemNumbers: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
        }
        .background(Color.PresetColour.darkgrey)
        .toolbarBackground(Color.PresetColour.darkgrey, for: .navigationBar)
        .onAppear {
            Task {
                let response = await profileViewModel.viewMoreForCurrentUser(forItem: .topArtists)
                switch response {
                case .artists(let artistsWithMetadata):
                    topArtists = artistsWithMetadata ?? ProfileViewModel.ArtistsWithResponseMetadata(artists: [])
                default:
                    // It should not end up in this case.
                    topArtists = ProfileViewModel.ArtistsWithResponseMetadata(artists: [])
                }
            }
        }
        .onChange(of: selectedTimeRange) {
            Task {
                let response = await profileViewModel.viewMoreForCurrentUser(forItem: .topArtists, timeRange: selectedTimeRange)
                switch response {
                case .artists(let artistsWithMetadata):
                    topArtists = artistsWithMetadata ?? ProfileViewModel.ArtistsWithResponseMetadata(artists: [])
                default:
                    // It should not end up in this case.
                    topArtists = ProfileViewModel.ArtistsWithResponseMetadata(artists: [])
                }
            }
        }
    }
}

#Preview {
    ZStack {
        let user = UserMock.userJimHalpert
        let profile = SpotifyProfileMock.jimHalpert
        let topArtists = [
            ArtistMock.jonBellion, ArtistMock.kaceyMusgraves, ArtistMock.oliviaRodrigo, ArtistMock.zachBryan,
            ArtistMock.jonBellion, ArtistMock.kaceyMusgraves, ArtistMock.oliviaRodrigo, ArtistMock.zachBryan,
            ArtistMock.jonBellion, ArtistMock.kaceyMusgraves, ArtistMock.oliviaRodrigo, ArtistMock.zachBryan,
            ArtistMock.jonBellion, ArtistMock.kaceyMusgraves, ArtistMock.oliviaRodrigo, ArtistMock.zachBryan,
            ArtistMock.jonBellion, ArtistMock.kaceyMusgraves, ArtistMock.oliviaRodrigo, ArtistMock.zachBryan
        ]
        ViewMoreTopArtists(profile: profile, topArtists: topArtists)
            .environmentObject(ProfileViewModel(user: user))
    }
}
