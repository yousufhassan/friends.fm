import SwiftUI

struct v1_2_2: View {
    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                Text("[v1.2.2]")
                    .font(.title2)
                    .bold()
                Spacer()
            }
            .padding(.bottom, 4)
            Text(
"""
• Added profile data for 6 months and 1 year
• UI improvements
"""
            )
        }
    }
}

#Preview {
    v1_2_2()
}
