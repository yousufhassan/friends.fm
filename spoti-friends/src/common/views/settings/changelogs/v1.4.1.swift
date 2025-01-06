import SwiftUI

struct v1_4_1: View {
    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                Text("[v1.4.1]")
                    .font(.title2)
                    .bold()
                Spacer()
            }
            .padding(.bottom, 4)
            Text(
"""
• Improved UI/UX for song sharing page
• Integrated analytics for better app experience
"""
            )
        }
    }
}

#Preview {
    v1_4_1()
}
