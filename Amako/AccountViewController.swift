//
//  AccountViewController.swift
//  Amako
//
//  Created by Amosy . on 30/1/22.
//

import UIKit
import FirebaseAuth

class AccountViewController: UIViewController {

    @IBOutlet weak var usernameLbl: UILabel!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameLbl.text = "Welcome Back, " + appDelegate.user.username
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        usernameLbl.text = "Welcome Back, " + appDelegate.user.username
    }
    
    @IBAction func logOutBtn(_ sender: Any) {
        logOut()
    }
    
    func logOut(){
        do
            {
                try Auth.auth().signOut()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let logInPage = storyboard.instantiateViewController(withIdentifier: "logInPage") as UIViewController
                logInPage.modalPresentationStyle = .fullScreen
                present(logInPage, animated: true, completion: nil)
            }
            catch let error as NSError
            {
                print(error.localizedDescription)
            }
    }
}
