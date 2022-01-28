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
    func createUser(email: String, password: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
            if let user = authResult?.user {
                print(user)
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
//                ref.child("Users").child(uid).observeSingleEvent(of: .value, with: { snapshot in
//                    guard let value = snapshot.value as? [String: Any] else{
//                        return
//                    }
//                    print("Value: \(value)")
//                    favMangaIDList.append(value)
//                })
                ref.child("Users").child(uid).getData(completion:  { error, snapshot in
                  guard error == nil else {
                    print(error!.localizedDescription)
                    return;
                  }
                    
                    let snap = snapshot.value as! [String:AnyObject]
//                    let favouriteList = snap["Favourites"] as! [Int:AnyObject]
                    let username = snap["Username"] as! String
                    var user = User(UserID: uid, Username: username)
//                    for i in favouriteList {
//
//                    }
                    
                    let user = User(UserID: uid, Username: username)
                    for i in snap["Favourites"]! as! [NSDictionary]
                    {
                        print("Adding favourite")
                        user.addfavourite(Manga: Manga(MangaID: i["mangaID"] as! String, FileName: i["fileName"] as? String))
                    }
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.user = user
                    print(appDelegate.user.favourites[1].mangaID!)
                });
                completionBlock(true)
            }
        }
    }
    
}
