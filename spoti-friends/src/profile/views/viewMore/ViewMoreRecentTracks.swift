import SwiftUI

/// A SwiftUI view that displays a user's recent songs.
/// This view is part of a navigation stack and shows a scrollable list of tracks.
///
/// - Parameters:
///   - profile: The Spotify Profile to show the data for.
///
struct ViewMoreRecentTracks: View {
    let profile: SpotifyProfile
    @State private var recentTracks: ProfileViewModel.TracksWithResponseMetadata
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    
    init(profile: SpotifyProfile, recentTracks: [Track] = []) {
        self.profile = profile
        self.recentTracks = ProfileViewModel.TracksWithResponseMetadata(tracks: recentTracks)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Recent Songs")
                    .foregroundStyle(Color.PresetColour.whitePrimary)
                    .font(.title2)
                TrackList(tracks: recentTracks.tracks)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
        }
        .background(Color.PresetColour.darkgrey)
        .toolbarBackground(Color.PresetColour.darkgrey, for: .navigationBar)
        .onAppear {
            Task {
                let response = await profileViewModel.viewMore(forProfile: profile, forItem: .recentTracks)
                switch response {
                case .tracks(let tracksWithMetadata):
                    recentTracks = tracksWithMetadata ?? ProfileViewModel.TracksWithResponseMetadata(tracks: [])
                default:
                    // It should not end up in this case.
                    recentTracks = ProfileViewModel.TracksWithResponseMetadata(tracks: [])
                }
            }
        }
    }
}

#Preview {
    ZStack {
        let user = UserMock.userJimHalpert
        let profile = SpotifyProfileMock.jimHalpert
        let recentTracks = [
            TrackMock.iRememberEverything, TrackMock.luxury, TrackMock.traitor,
            TrackMock.iRememberEverything, TrackMock.luxury, TrackMock.traitor,
            TrackMock.iRememberEverything, TrackMock.luxury, TrackMock.traitor,
            TrackMock.iRememberEverything, TrackMock.luxury, TrackMock.traitor,
            TrackMock.iRememberEverything, TrackMock.luxury, TrackMock.traitor,
            TrackMock.iRememberEverything, TrackMock.luxury, TrackMock.traitor,
            TrackMock.iRememberEverything, TrackMock.luxury
        ]
        ViewMoreRecentTracks(profile: profile, recentTracks: recentTracks)
            .environmentObject(ProfileViewModel(user: user))
    }
}
