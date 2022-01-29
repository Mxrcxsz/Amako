//
//  SignUpViewController.swift
//  Amako
//
//  Created by Amosy . on 29/1/22.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameFld: UITextField!
    @IBOutlet weak var emailFld: UITextField!
    @IBOutlet weak var passwordFld: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpBtn(_ sender: Any) {
        signUp(username: usernameFld.text!, email: emailFld.text!, password: passwordFld.text!)
    }
    
    @objc func signUp(username:String,email:String, password:String) {
        let signUpManager = FirebaseAuthManager()
        signUpManager.createUser(username:username, email: email, password: password) {[weak self] (success) in
            guard self != nil else { return }
            var message: String = ""
            if (success) {
                message = "User was sucessfully created."
            } else {
                message = "There was an error."
            }
            let signUpResultAlert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            signUpResultAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self!.present(signUpResultAlert, animated: true)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
