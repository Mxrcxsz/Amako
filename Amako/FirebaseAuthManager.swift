//
//  FirebaseAuthManager.swift
//  MAD2_ASG
//
//  Created by Khim Chua on 26/1/22.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class FirebaseAuthManager {
    func createUser(username: String,email: String, password: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
            if let user = authResult?.user {
                let ref: DatabaseReference! =  Database.database().reference()
                ref.child("Users").child(user.uid).child("Username").setValue(username)
                
                let user = User(UserID: user.uid, Username: username)
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.user = user
                completionBlock(true)
            } else {
                completionBlock(false)
            }
        }
    }
    
    func signIn(email: String, pass: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: pass) { (result, error) in
            if let error = error, let _ = AuthErrorCode(rawValue: error._code) {
                completionBlock(false)
            } else {
                let uid = result!.user.uid
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
                            user.addfavourite(favouriteManga: Manga(MangaID: i["mangaID"] as! String, CoverURL: i["fileName"] as! String))
                        }
                    }
                    else{
                        print("No saved manga")
                    }
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.user = user
                });
                completionBlock(true)
            }
        }
    }
    
}
