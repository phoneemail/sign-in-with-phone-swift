import UIKit
import WebKit

class WebMailViewController: UIViewController, WKNavigationDelegate {
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = self
        view.addSubview(webView)

        let url = URL(string: "https://web.phone.email/")!
        let request = URLRequest(url: url)
        webView.load(request)
    }

    // MARK: - WKNavigationDelegate

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // Handle URL loading within the WebView
        if let url = navigationAction.request.url {
            print("shouldOverrideUrlLoading: URL: \(url)")
            decisionHandler(.allow)
        } else {
            decisionHandler(.cancel)
        }
    }
}
