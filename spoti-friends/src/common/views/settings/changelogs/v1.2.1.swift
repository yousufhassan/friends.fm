import SwiftUI

struct v1_2_1: View {
    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                Text("[v1.2.1]")
                    .font(.title2)
                    .bold()
                Spacer()
            }
            .padding(.bottom, 4)
            Text(
"""
• Added page with more detailed profile data
• Displayed error when there was an issue logging in
• Bug fixes
"""
            )
        }
    }
}

#Preview {
    v1_2_1()
}
