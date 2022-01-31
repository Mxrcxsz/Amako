//
//  AccountViewController.swift
//  Amako
//
//  Created by Khim Chua on 27/1/22.
//

import UIKit

class LogInViewController: UIViewController {
    var appDelegate = (UIApplication.shared.delegate) as! AppDelegate
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func signUpBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signUpPage = storyboard.instantiateViewController(withIdentifier: "signUpPage") as UIViewController
        signUpPage.modalPresentationStyle = .fullScreen
        present(signUpPage, animated: true, completion: nil)
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        login(email: emailTxt.text!, password: passwordTxt.text!)
    }
    
    @objc func login(email:String, password:String) {
        let loginManager = FirebaseAuthManager()
            loginManager.signIn(email: email, pass: password) {[weak self] (success) in
                guard let `self` = self else { return }
                var message: String = ""
                if (success) {
                    message = "User was sucessfully logged in."
                    let storyboard = UIStoryboard(name: "Content", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "Content") as UIViewController
                    vc.modalPresentationStyle = .fullScreen //try without fullscreen
                    self.present(vc, animated: true, completion: nil)
                } else {
                    message = "There was an error."
                }
                let loginResultAlert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                loginResultAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(loginResultAlert, animated: true)
            }
    }
    
    
    @IBAction func skip(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Content", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Content") as UIViewController
        vc.modalPresentationStyle = .fullScreen //try without fullscreen
        self.present(vc, animated: true, completion: nil)
    }
    
    
}
