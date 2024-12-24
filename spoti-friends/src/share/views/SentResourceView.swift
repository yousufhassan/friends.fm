import SwiftUI

struct SentResourceView: View {
    let resource: SharedResource
    var body: some View {
        HStack {
            if (resource.getType() == .track) {
                TrackView(track: resource.getResource() as! Track)
            }
            
            Spacer()
            ProfileImage(profile: resource.getReceiver(), width: 24, height: 24)
        }
    }
}

#Preview {
    let sender = UserMock.userJimHalpert
    let receiver = SpotifyProfileMock.michaelScott
    let resource = SharedResource(resource: TrackMock.iRememberEverything, sender: sender, receiver: receiver)
    SentResourceView(resource: resource)
}
