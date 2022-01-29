//
//  AccountViewController.swift
//  Amako
//
//  Created by Khim Chua on 27/1/22.
//

import UIKit

class AccountViewController: UIViewController {
    var appDelegate = (UIApplication.shared.delegate) as! AppDelegate
    
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func signUpBtn(_ sender: Any) {
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
                } else {
                    message = "There was an error."
                }
                let loginResultAlert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                loginResultAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(loginResultAlert, animated: true)
            }
    }
}
