//
//  SplashScreenViewController.swift
//  Amako
//
//  Created by Khim Chua on 1/2/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SplashScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1)
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as UIViewController
            vc.modalPresentationStyle = .fullScreen //try without fullscreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func presentView(){
        if Auth.auth().currentUser != nil && UserDefaults.standard.string(forKey: "Email") != nil && UserDefaults.standard.string(forKey: "Password") != nil{
            let uid = Auth.auth().currentUser!.uid
            let ref: DatabaseReference! =  Database.database().reference()
            
            ref.child("Users").child(uid).getData(completion:  { error, snapshot in
              guard error == nil else {
                print(error!.localizedDescription)
                return;
              }
                let snap = snapshot.value as? [String:AnyObject]
                let username = snap!["Username"] as! String
                let user = User(UserID: uid, Username: username)
                if snap!["Favourites"] != nil{
                    for i in snap!["Favourites"]! as! [NSDictionary]
                    {
                        print("Adding favourite")
                        user.addfavourite(favouriteManga: Manga(MangaID: i["mangaID"] as! String, CoverURL: i["coverUrl"] as! String, Title: i["title"] as! String))
                    }
                }
                else{
                    print("No saved manga")
                }
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.user = user
            });
        }
        else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as UIViewController
            vc.modalPresentationStyle = .fullScreen //try without fullscreen
            self.present(vc, animated: true, completion: nil)
        }
    }
}
