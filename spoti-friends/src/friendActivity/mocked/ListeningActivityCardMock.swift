import Foundation
import SwiftUI

/// Struct containing mock Listening Activity Card objects.
struct ListeningActivityCardMock {
    static let allCards = [michaelScottActivity, dwightSchruteActivity, stanleyHudsonActivity]
    
    static let michaelScottActivity = createMockListeningActivityCard(profile: SpotifyProfileMock.michaelScott,
                                                                      backgroundColor: Color.gray)
    
    static let dwightSchruteActivity = createMockListeningActivityCard(profile: SpotifyProfileMock.dwightSchrute,
                                                                       backgroundColor: Color.pink)
    
    static let stanleyHudsonActivity = createMockListeningActivityCard(profile: SpotifyProfileMock.stanleyHudson,
                                                                       backgroundColor: Color.yellow)
    
    static func createMockListeningActivityCard(profile: SpotifyProfile, backgroundColor: Color) -> ListeningActivityCard {
        return ListeningActivityCard(profile: profile, backgroundColor: backgroundColor)
    }
}
