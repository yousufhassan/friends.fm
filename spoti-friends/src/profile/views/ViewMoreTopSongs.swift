import SwiftUI

/// A SwiftUI view that displays a user's top songs.
/// This view is part of a navigation stack and shows a scrollable list of tracks.
///
/// - Parameters:
///   - profile: The Spotify Profile to show the data for.
///
struct ViewMoreTopSongs: View {
    let profile: SpotifyProfile
    @State private var topTracks: ProfileViewModel.TracksWithResponseMetadata
    @State private var selectedTimeRange: ProfileViewModel.TimeRange = .oneMonth
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    
    init(profile: SpotifyProfile, topTracks: [Track] = []) {
        self.profile = profile
        self.topTracks = ProfileViewModel.TracksWithResponseMetadata(tracks: topTracks)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Top Songs")
                    .foregroundStyle(Color.PresetColour.whitePrimary)
                    .font(.title2)
                
                HStack {
                    Spacer()
                    TimeRangeSelector(selectedTimeRange: $selectedTimeRange)
                    Spacer()
                }
                .padding(.vertical, 8)
                
                TrackList(tracks: topTracks.tracks, showItemNumbers: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
        }
        .background(Color.PresetColour.darkgrey)
        .toolbarBackground(Color.PresetColour.darkgrey, for: .navigationBar)
        .onAppear {
            Task {
                let response = await profileViewModel.viewMoreForCurrentUser(forItem: .topTracks)
                switch response {
                case .tracks(let tracksWithMetadata):
                    topTracks = tracksWithMetadata ?? ProfileViewModel.TracksWithResponseMetadata(tracks: [])
                default:
                    // It should not end up in this case.
                    topTracks = ProfileViewModel.TracksWithResponseMetadata(tracks: [])
                }
            }
        }
        .onChange(of: selectedTimeRange) {
            Task {
                let response = await profileViewModel.viewMoreForCurrentUser(forItem: .topTracks, timeRange: selectedTimeRange)
                switch response {
                case .tracks(let tracksWithMetadata):
                    topTracks = tracksWithMetadata ?? ProfileViewModel.TracksWithResponseMetadata(tracks: [])
                default:
                    // It should not end up in this case.
                    topTracks = ProfileViewModel.TracksWithResponseMetadata(tracks: [])
                }
            }
        }
    }
}

#Preview {
    ZStack {
        let user = UserMock.userJimHalpert
        let profile = SpotifyProfileMock.jimHalpert
        let topTracks = [
            TrackMock.iRememberEverything, TrackMock.luxury, TrackMock.traitor,
            TrackMock.iRememberEverything, TrackMock.luxury, TrackMock.traitor,
            TrackMock.iRememberEverything, TrackMock.luxury, TrackMock.traitor,
            TrackMock.iRememberEverything, TrackMock.luxury, TrackMock.traitor,
            TrackMock.iRememberEverything, TrackMock.luxury, TrackMock.traitor,
            TrackMock.iRememberEverything, TrackMock.luxury, TrackMock.traitor,
            TrackMock.iRememberEverything, TrackMock.luxury
        ]
        ViewMoreTopSongs(profile: profile, topTracks: topTracks)
            .environmentObject(ProfileViewModel(user: user))
    }
}
