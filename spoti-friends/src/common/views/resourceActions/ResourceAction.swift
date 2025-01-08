import SwiftUI

struct ResourceAction: View {
    let action: ResourceActionType
    
    var body: some View {
        Button(action: action.action) {
            HStack {
                action.icon
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                    .padding(.trailing, 4)
                
                Text(action.label)
                    .foregroundStyle(Color.PresetColour.whitePrimary)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
            .padding(.horizontal)
            .padding(.vertical, 12)
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
