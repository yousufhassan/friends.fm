import SwiftUI
import WebKit

/// A SwiftUI view that wraps a WKWebView to handle Spotify authorization.
struct AuthorizationWebView: UIViewRepresentable {
    let url: URL
    @EnvironmentObject var userViewModel: AuthorizationViewModel
    @Binding var showWebView: Bool
    @Binding var responseUrl: URL?
    
    /// Creates a coordinator to act as the navigation delegate.
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    /// Creates the WKWebView instance.
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    /// Updates the WKWebView with the provided URL.
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    /// Coordinator class to handle navigation actions and fetch cookies.
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: AuthorizationWebView
        
        init(_ parent: AuthorizationWebView) {
            self.parent = parent
        }
        
        /// Decides how to handle navigation actions.
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            let appUrlScheme: String = "spoti-friends"
            if let url = navigationAction.request.url, url.scheme == appUrlScheme {
                // Handle the redirect URL
                parent.responseUrl = url
                parent.showWebView = false
                
                // Fetch sp_dc cookie from the web view
                let cookieName: String = "sp_dc"
                webView.configuration.websiteDataStore.httpCookieStore.fetchCookie(named: cookieName) { cookie in
                    self.parent.userViewModel.handleFetchedSpDcCookie(cookie)
                }
                
                decisionHandler(.cancel)
                return
            }
            decisionHandler(.allow)
        }
    }
}

extension WKHTTPCookieStore {
    /// Fetches cookie with the following `name`.
    func fetchCookie(named name: String, completion: @escaping (HTTPCookie?) -> Void) {
        self.getAllCookies { cookies in
            let specificCookie = cookies.first { $0.name == name }
            completion(specificCookie)
        }
    }
}


//#Preview {
//    AuthorizationWebView(url: spotifyAuthUrl, showWebView: true, responseUrl: "")
//}
