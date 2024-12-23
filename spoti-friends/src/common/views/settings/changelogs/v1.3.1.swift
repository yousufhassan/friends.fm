import SwiftUI

struct v1_3_1: View {
    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                Text("[v1.3.1]")
                    .font(.title2)
                    .bold()
                Spacer()
            }
            .padding(.bottom, 4)
            Text(
"""
• Prepared app for App Store release
• Added a settings page
"""
            )
        }
    }
}

#Preview {
    v1_3_1()
}
