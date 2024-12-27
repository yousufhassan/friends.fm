//
//  SentSongsTab.swift
//  spoti-friends
//
//  Created by Yousuf Hassan on 2024-12-26.
//

import SwiftUI

struct SentSongsTab: View {
    @Binding var sentResources: [SharedResource]
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(groupedResources(sentResources: sentResources), id: \.0) { key, resources in
                    SentResourceView(
                        resource: resources.first!,
                        receivers: resources.map { $0.getReceiver() }
                    )
                }
                
            }
            .padding(.leading)
        }
    }
}

private func groupedResources(sentResources: [SharedResource]) -> [(String, [SharedResource])] {
    let grouped = Dictionary(grouping: sentResources) { resource in
        "\(resource.getSharedTs())-\(resource.getResourceId())"
    }
    return grouped.map { ($0.key, $0.value) }
}

#Preview {
    @Previewable @State var sentResources = SharedResourceMock.sentResources
    
    SentSongsTab(sentResources: $sentResources)
}
