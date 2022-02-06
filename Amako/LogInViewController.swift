//
//  AccountViewController.swift
//  Amako
//
//  Created by Khim Chua on 27/1/22.
//

import UIKit

class LogInViewController: UIViewController {
    var appDelegate = (UIApplication.shared.delegate) as! AppDelegate
    var message: String = ""
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signUpPage = storyboard.instantiateViewController(withIdentifier: "SignUpVC") as UIViewController
        signUpPage.modalPresentationStyle = .fullScreen
        present(signUpPage, animated: true, completion: nil)
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        let mailTxt = emailTxt.text!.components(separatedBy: .whitespaces).joined()
        login(email: mailTxt, password: passwordTxt.text!)
    }
    
    @objc func login(email:String, password:String) {
        if emailTxt.text == "" || passwordTxt.text == "" {
            message = "Please fill in all inputs"
            showAlert(message: message)
        }
        let loginManager = FirebaseAuthManager()
            loginManager.signIn(email: email, pass: password) {[weak self] (success) in
                guard let `self` = self else { return }
                if (success) {
                    self.message = "User was sucessfully logged in."
                    let storyboard = UIStoryboard(name: "Content", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "Content") as UIViewController
                    vc.modalPresentationStyle = .fullScreen //try without fullscreen
                    self.present(vc, animated: true, completion: nil)
                } else {
                    self.message = "Wrong Login Details."
                }
                self.showAlert(message: self.message)
            }
    }
    
    func showAlert(message:String){
        let loginResultAlert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        loginResultAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(loginResultAlert, animated: true)
    }
}
