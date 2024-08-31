import SwiftUI

/// A View that renders a generic error message stating that something went wrong.
struct SomethingWentWrongView: View {
    var body: some View {
        VStack {
            Spacer()
            
            // Error page title
            Text("Oops...")
                .foregroundStyle(Color.PresetColour.whitePrimary)
                .font(.title)
                .fontWeight(.bold)
            
            // Error image
            Text("☹️")
                .foregroundStyle(.white)
                .font(.system(size: 180))
                .padding(.vertical)
            
            // Explanation text
                Text("Something went wrong.\n\n Please retry or come back later. If the issue persists, consider reaching out at friends.fm.app@gmail.com")
            .foregroundStyle(Color.PresetColour.whitePrimary)
            .multilineTextAlignment(.center)
            
            Spacer()
            Spacer()
        }
        .padding()
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
        .background(backgroundGradient)
    }
}

#Preview {
    SomethingWentWrongView()
}
