import SwiftUI

/// A View representing an action that can be taken on a Spotify resource.
///
/// `ResourceAction` provides a customizable button that displays an icon and a label,
/// and executes the associated action when tapped.
///
/// - Parameters:
///   - action: The `ResourceActionType` defining the label, icon, and behavior of the action.
///   - actionColor: An optional `Color` to customize the foreground color of the action.
///
/// - Note:
///   This view is intended to be used in a list or group of resource actions, such as within an action sheet.
struct ResourceAction: View {
    let action: ResourceActionType
    var actionColor: Color?
    
    init(action: ResourceActionType) {
        self.action = action
        if (action.label == ResourceActionType.Label.unsend.rawValue) {
            self.actionColor = Color.PresetColour.red
        }
    }
    
    var body: some View {
        
        Button(action: action.action) {
            HStack {
                action.icon
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                    .padding(.trailing, 4)
                    .foregroundStyle(actionColor ?? Color.PresetColour.gray)
                
                Text(action.label)
                    .foregroundStyle(actionColor ?? Color.PresetColour.whitePrimary)
                
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
