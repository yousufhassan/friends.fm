import Foundation
import SwiftUI

/// An enum containing the different types of errors that can happen when attepming to add an item  to the user's queue.
enum AddToQueueError: Error {
    case noActiveDevice
    case premiumRequired
    case unknown
}

/// A view that returns an error sheet for when the user cannot add an item to their queue because there was no active device found.
struct NoActiveDeviceErrorSheet: View {
    var body: some View {
        VStack {
            Text("Session not found")
                .font(.title2)
                .padding(.vertical, 8)
                .foregroundStyle(Color.PresetColour.spotifyGreen)
            
            Divider()
            
            VStack (spacing: 24) {
                Text("Adding a song to your queue requires an active Spotify session.")
                Text("Start playing music on any device to add songs to your queue!")
                
            }
            .multilineTextAlignment(.center)
            .foregroundStyle(Color.PresetColour.whiteSecondary)
            .font(.callout)
            .padding(.horizontal)
            .padding(.top)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical)
        .presentationDetents([.fraction(0.3)])
    }
}

/// A view that returns an error sheet for when the user cannot perform an action because it requires a Spotify Premium subscription.
struct PremiumRequiredErrorSheet: View {
    var body: some View {
        VStack {
            Text("Requires Spotify Premium")
                .font(.title2)
                .padding(.vertical, 8)
                .foregroundStyle(Color.PresetColour.spotifyGreen)
            
            Divider()
            
            VStack (spacing: 24) {
                Text("The action you attempted is only available on Premium.")
                Text("Spotify Premium lets you play any track, podcast episode or audiobook, ad-free and with better audio quality. Go to [spotify.com/premium](https://spotify.com/premium) to try it for free.")
            }
            .multilineTextAlignment(.center)
            .foregroundStyle(Color.PresetColour.whiteSecondary)
            .font(.callout)
            .padding(.horizontal)
            .padding(.top)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical)
        .presentationDetents([.fraction(0.35)])
    }
}

#Preview {
    @Previewable @State var showNoActiveDeviceSheet = false
    @Previewable @State var showPremiumRequiredSheet = true
    
    Button("Open \"No active device\" sheet") {
        showNoActiveDeviceSheet = true
    }
    .sheet(isPresented: $showNoActiveDeviceSheet) {
        NoActiveDeviceErrorSheet()
    }
    
    Button("Open \"Premium required\" sheet") {
        showPremiumRequiredSheet = true
    }
    .sheet(isPresented: $showPremiumRequiredSheet) {
        PremiumRequiredErrorSheet()
    }
}
