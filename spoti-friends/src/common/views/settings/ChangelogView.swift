import SwiftUI

struct ChangelogView: View {
    var body: some View {
        ScrollView {
            PageTitle(pageTitle: "Changelog")
            Divider()
                .padding(.bottom)
            
            v1_3_0()
            Divider()
                .padding(.bottom)
            
            v1_2_2()
            Divider()
                .padding(.bottom)
            
            v1_2_1()
            Divider()
                .padding(.bottom)
            
        }
        .padding()
        .background(Color.PresetColour.darkgrey)
    }
}

#Preview {
    ChangelogView()
}
