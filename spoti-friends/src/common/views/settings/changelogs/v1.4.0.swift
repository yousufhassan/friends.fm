import SwiftUI

struct v1_4_0: View {
    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                Text("[v1.4.0]")
                    .font(.title2)
                    .bold()
                Spacer()
            }
            .padding(.bottom, 4)
            Text(
"""
• Introduced new song sharing feature
• Allowed users to invite their friends to the app
"""
            )
        }
    }
}

#Preview {
    v1_4_0()
}
