import SwiftUI

struct v1_3_0: View {
    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                Text("[v1.3.0]")
                    .font(.title2)
                    .bold()
                Spacer()
            }
            .padding(.bottom, 4)
            Text(
"""
• Migrated to new database
• Added friend profile view feature
"""
            )
        }
    }
}

#Preview {
    v1_3_0()
}
