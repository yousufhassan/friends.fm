import Foundation
import SwiftUI

let backgroundGradient: LinearGradient = LinearGradient(gradient: Color.PresetGradient.mainDarkGradient, startPoint: .top, endPoint: .bottom)

extension Color {
    struct PresetColour {
        static var spotifyGreen: Color { return Color(red: 0.11, green: 0.72, blue: 0.33) }
        static var whitePrimary: Color { return Color(red: 0.94, green: 0.94, blue: 0.94) }
        static var whiteSecondary: Color { return Color(red: 0.77, green: 0.77, blue: 0.77) }
        static var black: Color { return Color(red: 0.03, green: 0.03, blue: 0.03) }
        static var darkgrey: Color { return Color(red: 0.11, green: 0.11, blue: 0.11) }
        static var navbar: Color { return Color(red: 0.10, green: 0.10, blue: 0.10) }
        static var red: Color { return Color(red: 0.74, green: 0.11, blue: 0.11) }
        static var transparentMaroon: Color { return Color(red: 0.38, green: 0.16, blue: 0.16, opacity: 0.55) }
    }
    
    struct PresetGradient {
        static var mainDarkGradient: Gradient {return  Gradient(colors: [Color(red: 0.12, green: 0.12, blue: 0.12), Color(red: 0.06, green: 0.06, blue: 0.06)])}
    }
    
    func isDarkBackground() -> Bool {
            var r, g, b, a: CGFloat
            (r, g, b, a) = (0, 0, 0, 0)
            UIColor(self).getRed(&r, green: &g, blue: &b, alpha: &a)
            let luminance = 0.2126 * r + 0.7152 * g + 0.0722 * b
            return  luminance < 0.30

        }
}
