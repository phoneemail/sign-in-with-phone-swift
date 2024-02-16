import UIKit
import WebKit

class AuthViewController: UIViewController, WKScriptMessageHandler, WKNavigationDelegate {
    
    var webView: WKWebView!
    let phoneCountry = "+91"
    let phoneNumber = "**********"
    var deviceId = ""
    
    @IBOutlet weak var webContentView: UIView!
    var didReceiveJWT: ((String?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let contentController = WKUserContentController()
        contentController.add(self, name: "callbackHandler")
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        self.webView = WKWebView(frame: self.webContentView.bounds, configuration: config)
        self.webView.navigationDelegate = self
        self.webContentView.addSubview(webView)
        
        deviceId = UIDevice.current.identifierForVendor?.uuidString ?? ""
        
        let urlString = "https://auth.phone.email/sign-in?countrycode=\(phoneCountry)&phone_no=\(phoneNumber)&auth_type=7&device=\(deviceId)"
        

        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    // MARK: - WKScriptMessageHandler
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message)
        
        if message.name == "callbackHandler", let data = message.body as? String {
            print("sendTokenToApp: \(data)")
            
            // Handle the received data as needed
            didReceiveJWT?(data)
            
            // Dismiss the AuthViewController
            dismiss(animated: true, completion: nil)
        }
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
