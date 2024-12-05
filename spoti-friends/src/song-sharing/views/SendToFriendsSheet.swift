import SwiftUI

struct SendToFriendsSheet: View {
    let track: Track
    let friends: [SpotifyProfile]
    
    // Define the grid layout with 3 columns and spacing
    let threeColumns = [GridItem(.flexible(), spacing: 8),
                        GridItem(.flexible(), spacing: 8),
                        GridItem(.flexible(), spacing: 8)]
    
    var body: some View {
        VStack {
            Text("Send to")
                .bold()
            
            ScrollView {
                LazyVGrid(columns: threeColumns, spacing: 8) {
                    ForEach(friends) { friend in
                        VStack(spacing: 8) {
                            // Image - fixed size for all items to keep them aligned
                            ImageWithSpecs(imageUrl: friend.image, width: 64, height: 64, cornerRadius: 100)
                                .padding(.horizontal)
                            
                            // Text - limited to two lines and centered
                            Text(friend.displayName)
                                .foregroundStyle(Color.PresetColour.whiteSecondary)
                                .font(.footnote)
                                .lineLimit(1)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical)
                    }
                }
                .padding(.horizontal, 8)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top)
        .presentationDetents([.medium, .large])
    }
}


#Preview {
    @Previewable @State var showSheet = true
    let track = TrackMock.traitor
    let friends = [SpotifyProfileMock.dwightSchrute, SpotifyProfileMock.jimHalpert,
                   SpotifyProfileMock.michaelScott, SpotifyProfileMock.stanleyHudson]
    
    Button("Open sheet") {
        showSheet = true
    }
    .sheet(isPresented: $showSheet) {
        SendToFriendsSheet(track: track, friends: friends)
    }
}
