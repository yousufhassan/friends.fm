import SwiftUI
import SafariServices

struct SettingsView: View {
    @State private var isShowingSafariView = false
    @State private var externalUrl: URL?
    
    var body: some View {
        VStack {
            PageTitle(pageTitle: "Settings")
            
            List {
                Group {
                    NavigationLink(destination: Text("Changelog")) {
                        Text("Changelog")
                    }
                    
                    // Privacy Policy - opens in SafariView
                    ExternalLinkListItem(label: "Privacy Policy",
                                         redirectUrl: "https://www.google.com",
                                         isShowingSafariView: $isShowingSafariView,
                                         externalUrl: $externalUrl)
                    
                    // License Agreement - opens in SafariView
                    ExternalLinkListItem(label: "License Agreement",
                                         redirectUrl: "https://www.google.com",
                                         isShowingSafariView: $isShowingSafariView,
                                         externalUrl: $externalUrl)
                    
                    // App version
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.3.0")
                            .foregroundStyle(Color.PresetColour.whiteSecondary)
                    }
                }
                .listRowBackground(Color.PresetColour.darkgrey)
                .foregroundStyle(Color.PresetColour.whitePrimary)
            }
            .scrollContentBackground(.hidden)
            .listStyle(PlainListStyle())
            
            Spacer()
            
            LogoutButton()
        }
        .background(Color.PresetColour.darkgrey)
        .sheet(isPresented: $isShowingSafariView) {
            if let url = externalUrl {
                SafariView(url: url)
            }
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}

struct ExternalLinkListItem: View {
    let label: String
    let redirectUrl: String
    @Binding var isShowingSafariView: Bool
    @Binding var externalUrl: URL?
    
    var body: some View {
        Button(action: {
            self.externalUrl = URL(string: redirectUrl)
            self.isShowingSafariView = true
        }) {
            HStack {
                Text(label)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 7)
                    .foregroundStyle(Color(red: 0.4, green: 0.4, blue: 0.4))
            }
        }
    }
    
}

struct SafariView: View {
    let url: URL
    
    var body: some View {
        SafariViewControllerWrapper(url: url)
    }
}

struct SafariViewControllerWrapper: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}



// Logout button
struct LogoutButton: View {
    @EnvironmentObject private var authorizationViewModel: AuthorizationViewModel
    
    var body: some View {
        let buttonLabel = "Log out"
        Button(action: {
            authorizationViewModel.signOutUser()
        }) {
            Text(buttonLabel)
                .frame(width: 320, height: 50)
                .background(Color.PresetColour.transparentMaroon)
                .foregroundColor(Color.PresetColour.red)
                .fontWeight(.semibold)
                .cornerRadius(12)
        }
    }
}
