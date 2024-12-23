import SwiftUI
import SafariServices

/// A SwiftUI view that provides a settings page for the app.
///
/// This view includes:
/// - Navigation links to the Changelog, Privacy Policy, and License Agreement.
/// - A display of the app version retrieved from UserDefaults.
/// - A logout button at the bottom.
///
struct SettingsView: View {
    var appVersion: String = getStringFromUserDefaultsValueForKey("appVersion")
    
    var body: some View {
        VStack {
            PageTitle(pageTitle: "Settings")
                .padding()
            
            List {
                Group {
                    NavigationLink(destination: ChangelogView()) {
                        Text("Changelog")
                    }
                    
                    // Privacy Policy - opens in SafariView
                    ExternalLinkListItem(label: "Privacy Policy",
                                         redirectUrl: "https://friendsfm.super.site/privacy")
                    
                    // License Agreement - opens in SafariView
                    ExternalLinkListItem(label: "License Agreement",
                                         redirectUrl: "https://friendsfm.super.site/eula")
                    
                    // App version
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(appVersion)
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
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}

/// A SwiftUI view for a button that opens an external link.
///
/// Features:
/// - Displays a label and a right-facing chevron icon.
/// - Opens the specified URL in the default web browser.
/// 
struct ExternalLinkListItem: View {
    let label: String
    let redirectUrl: String
    
    var body: some View {
        Button(action: {
            let url = URL(string: redirectUrl)!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
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
