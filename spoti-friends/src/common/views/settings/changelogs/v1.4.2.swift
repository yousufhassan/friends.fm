import SwiftUI

struct v1_4_2: View {
    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                Text("[v1.4.2]")
                    .font(.title2)
                    .bold()
                Spacer()
            }
            .padding(.bottom, 4)
            Text(
"""
• Clicking on a track will now bring up a list of actions the user can take
"""
            )
        }
    }
}

#Preview {
    v1_4_2()
}
