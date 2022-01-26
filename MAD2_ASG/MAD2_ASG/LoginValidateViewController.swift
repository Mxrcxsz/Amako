//
//  LoginValidateViewController.swift
//  MAD2_ASG
//
//  Created by Amosy . on 26/1/22.
//

import UIKit

class LoginValidateViewController: UIViewController {

    @IBOutlet weak var emailFld: UITextField!
    @IBOutlet weak var passwordFld: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        guard let email = emailFld.text, !email.isEmpty,
              let password = passwordFld.text, !password.isEmpty else{
                  //return error message
                  return
              }
        //get auth instance
        //attempt sign in
        //if fail to sign in , alert to create account
        //alert: 'yes' to create account, 'no' to continue trying
        
        //check sign in on app launch
        //allow user to sign out with button
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: {[weak self]result, error in
            guard let strongSelf = self else {
                return
            }
            guard error == nil else{
                //show account creation alertchro
                strongSelf.showCreateAccount(email: email, password: password)
                return
        }
            print("You have signed in")
            strongSelf.emailFld.isHidden = true
            strongSelf.passwordFld.isHidden = true
        })
    }
    func showCreateAccount(email: String, password:String){
        let alert = UIAlertController(title: "Create Account",
                                      message: "Would you like to create an account",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Continue",
                                      style: .default,
                                      handler: {_ in
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: {[weak self] result, error in
                guard let strongSelf = self else {
                    return
                }
                guard error == nil else{
                    //print account creation failed
                    print("Account creation failed")
                    return
                }
                print("You have signed in")
                strongSelf.emailFld.isHidden = true
                strongSelf.passwordFld.isHidden = true
            })
        }))
        alert.addAction(UIAlertAction(title:"Cancel",
                                      style: .cancel,
                                      handler: {_ in
            
        }))
        present(alert, animated: true)
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
