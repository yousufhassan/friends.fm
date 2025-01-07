import SwiftUI

struct ResourceAction: View {
    let action: ResourceActionType
    
    var body: some View {
        Button(action: action.action) {
            HStack {
                action.icon
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 18, height: 18)
                
                Text(action.label)
                    .foregroundStyle(Color.PresetColour.whitePrimary)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
            .padding()
        }
        .buttonStyle(ResourceActionButtonStyle())
    }
}

#Preview {
    let resource = TrackMock.traitor
    
    ResourceAction(action: .openInSpotify(resource: resource))
}

struct ResourceActionButtonStyle: ButtonStyle {

  func makeBody(configuration: Configuration) -> some View {
    configuration.label
          .background(configuration.isPressed ? Color.PresetColour.spotifyBlack : Color.clear)
  }

}
