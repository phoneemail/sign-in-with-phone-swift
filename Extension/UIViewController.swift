import UIKit

extension UIViewController {

   
   func showAlert(message:String,completion: ((_ success:Bool)->Void)?){
       let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
       let action = UIAlertAction(title: "Ok", style: .default) { (alert) in
           completion?(true)
       }
       alert.addAction(action)
       present(alert, animated: true, completion: nil)
   }
   
   func showAlert(message:String){
       let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
       let action = UIAlertAction(title: "Ok", style: .default) { (alert) in
           
          // completion?(true)
       }
       alert.addAction(action)
       present(alert, animated: true, completion: nil)
   }
   
  
  
}
