//
//  SpotifyResourceView.swift
//  spoti-friends
//
//  Created by Yousuf Hassan on 2025-01-08.
//

import SwiftUI

struct SpotifyResourceView: View {
    let resource: SpotifyResource?
    var onTap: (() -> Void)?
    
    init(resource: SpotifyResource?, onTap: (() -> Void)? = nil) {
        if let resource = resource {
            self.resource = resource
            
            // Default behavior: open the track's Spotify URI
            self.onTap = onTap ?? {
                if let url = URL(string: resource.getSpotifyUri()) {
                    UIApplication.shared.open(url)
                }
            }
        }
        else {
            self.resource = nil
            self.onTap = nil
        }
    }
    
    var body: some View {
        if (resource == nil) {
            TrackOrArtistViewPlaceholder()
        } else {
            Button(action: {
                onTap?()
            }) {
                if (resource is Track) {
                    let track = resource as! Track
                    TrackView(track: track)
                }
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    SpotifyResourceView(resource: TrackMock.iRememberEverything)
}
