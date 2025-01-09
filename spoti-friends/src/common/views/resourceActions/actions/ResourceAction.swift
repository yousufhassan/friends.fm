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
                    .foregroundStyle(Color.PresetColour.gray)
                
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
    @Previewable @State var showSheet = true
    let resource = TrackMock.traitor
    
    ResourceAction(action: .goToAlbum(showSheet: $showSheet, track: resource))
}

struct ResourceActionButtonStyle: ButtonStyle {

  func makeBody(configuration: Configuration) -> some View {
    configuration.label
          .background(configuration.isPressed ? Color.PresetColour.spotifyBlack : Color.clear)
  }

}
