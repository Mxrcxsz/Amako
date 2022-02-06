//
//  AccountViewController.swift
//  Amako
//
//  Created by Khim Chua on 27/1/22.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {
    var appDelegate = (UIApplication.shared.delegate) as! AppDelegate
    var message: String = ""
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var checkBox: UIButton!
    var isChecked = false

    override func viewDidLoad() {
        super.viewDidLoad()
        checkBox.setImage(UIImage(named:"checkbox-check"), for: .selected)
        checkBox.setImage(UIImage(named:"checkbox-uncheck"), for: .normal)
        
        if UserDefaults.standard.string(forKey: "Email") != nil && UserDefaults.standard.string(forKey: "Password") != nil{
            checkBox.isSelected = !checkBox.isSelected
            isChecked = true
            emailTxt.text = UserDefaults.standard.string(forKey: "Email")!
            passwordTxt.text = UserDefaults.standard.string(forKey: "Password")!
        }
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
                    if self.isChecked{
                        UserDefaults.standard.set(self.emailTxt.text, forKey:"Email")
                        UserDefaults.standard.set(self.passwordTxt.text, forKey:"Password")
                        print("Email:", UserDefaults.standard.string(forKey: "Email"))
                    }
                    else{
                        UserDefaults.standard.removeObject(forKey: "Email")
                        UserDefaults.standard.removeObject(forKey: "Password")
                        print("Email:", UserDefaults.standard.string(forKey: "Email"))
                    }
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
    
    @IBAction func forgotPass(_ sender: Any) {
        let alert = UIAlertController(title: "Forgot Password", message: "Please enter the email you used to signup with", preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.placeholder = "Email"
        }

        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(textField!.text)")
            
            if textField!.text != ""{
                let auth = Auth.auth()
                auth.sendPasswordReset(withEmail: textField!.text!) { (error) in
                    if let error = error {
                        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                        self.present(alert, animated: true)
                        return
                    }
                    let alert = UIAlertController(title: "Sent", message: "An email has been sent", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func checkBoxClicked(_ sender: UIButton) {
        if sender.isSelected{
            isChecked = false
        }
        else{
            isChecked = true
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveLinear, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        })
        { (success) in
            UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveLinear, animations: {
                sender.isSelected = !sender.isSelected
                sender.transform = .identity
            }, completion: nil)
        }
    }
    
    func showAlert(message:String){
        let loginResultAlert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        loginResultAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(loginResultAlert, animated: true)
    }
}
