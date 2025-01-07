//
//  ResourceAction.swift
//  spoti-friends
//
//  Created by Yousuf Hassan on 2025-01-07.
//

import SwiftUI

struct ResourceAction: View {
    let icon: Image
    let label: String
    let action: () -> Void
    
    var body: some View {
        Button(action: { action() }) {
            HStack {
                icon
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 18, height: 18)
                
                Text(label)
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
    let icon = Image(.spotifyIconGreen)
    let label = "Open in Spotify"
    
    ResourceAction(icon: icon, label: label, action: {
        printInfo("Opening in Spotify")
    })
}

struct ResourceActionButtonStyle: ButtonStyle {

  func makeBody(configuration: Configuration) -> some View {
    configuration.label
          .background(configuration.isPressed ? Color.PresetColour.spotifyBlack : Color.clear)
  }

}
