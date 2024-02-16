 
import UIKit

class ViewController: UIViewController {

     @IBOutlet weak var emailView: TapableView!
     @IBOutlet weak var container: UIView!
     @IBOutlet weak var phoneButton: UIButton!
     @IBOutlet weak var emailCountLabel: UILabel!
     @IBOutlet weak var tvInfo: UILabel!
     @IBOutlet weak var tvJwt: UILabel!
     @IBOutlet weak var btnPhone: UIButton!
    
     var isLoggedIn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.phoneButton.addShadow()
        self.container.addShadow()
        emailView.isHidden = true
        showDetails(verifiedPhoneDetail: "", source: 7)
        emailCountLabel.layer.cornerRadius = emailCountLabel.frame.width / 2
        emailCountLabel.clipsToBounds = true
        emailView.onTap {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebMailViewController") as! WebMailViewController
            self.present(vc, animated: true, completion: nil)
        }
        
        showDetails(verifiedPhoneDetail: "",source: 7)
    }

    @IBAction func onLogin(_ sender: Any) {
        
        if !isLoggedIn {
            self.presentAuthViewController()
        } else {
             isLoggedIn = false
             showDetails(verifiedPhoneDetail: "", source: 7)
        }
        
    }
    
    
    
    private func showDetails(verifiedPhoneDetail: String, source: Int) {
            if source == 7 {
                tvInfo.text = NSLocalizedString("sign_in_text", comment: "")
                tvJwt.text = NSLocalizedString("sign_in_description", comment: "")
                btnPhone.setTitle(NSLocalizedString("sign_in_with_phone", comment: ""), for: .normal)
                emailView.isHidden = true
            } else {
                isLoggedIn = true
                tvInfo.text = NSLocalizedString("you_are_logged_in_with", comment: "")
                tvJwt.text = String(format: NSLocalizedString("phone_details", comment: ""), verifiedPhoneDetail)
                btnPhone.setTitle(NSLocalizedString("logout", comment: ""), for: .normal)
                 btnPhone.setImage(nil, for: .normal)
                emailView.isHidden = false
            }
        }
    
}
 

extension ViewController {
    
    func presentAuthViewController() {
        let authViewController = self.storyboard?.instantiateViewController(withIdentifier: "AuthViewController") as! AuthViewController
        authViewController.didReceiveJWT = { jwt in
            // Handle the result data, extract JWT if available
            if let jwt = jwt {
                print(jwt)
                
                let decodedClaims = JWTDecoder.decodeJWT(jwt)
                      
                if let phone = decodedClaims.phoneNo , !phone.isEmpty {
                    print("Issuer: \(decodedClaims.issuer ?? "")")
                    print("Audience: \(decodedClaims.audience ?? "")")
                    print("Country Code: \(decodedClaims.countryCode ?? "")")
                    print("Phone No: \(decodedClaims.phoneNo ?? "")")
                    self.showDetails(verifiedPhoneDetail: "\(decodedClaims.countryCode ?? "") \(decodedClaims.phoneNo ?? "")", source: 2)
                    self.getEmailCount(jwt: jwt)
                }else {
                    self.showAlert(message: "Something went wrong!!")
                }
            }else {
                self.showAlert(message: "Something went wrong!!")
            }
        }
        
        present(authViewController, animated: true, completion: nil)
    }
}



extension ViewController {
    
    private func getEmailCount(jwt: String) {
        ApiService.shared.getEmailCount(jwt: jwt) { result in
            switch result {
            case .success(let emailCount):
                DispatchQueue.main.async {
                    self.updateEmailCount(emailCount)
                }
            case .failure(let error):
                print("Error fetching email count: \(error)")
            }
        }
    }

    private func updateEmailCount(_ emailCount: String) {
        if emailCount.isEmpty {
            emailCountLabel.isHidden = true
        } else {
            emailCountLabel.text = emailCount
            emailCountLabel.isHidden = false
        }
    }
    
}
