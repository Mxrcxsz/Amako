//
//  LoggedInUser.swift
//  Amako
//
//  Created by Amosy . on 28/1/22.
//

import Foundation
import FirebaseDatabase

class User{
    var userID:String
    var username:String
    var favourites:[Manga] = []
    private var _ref: DatabaseReference!
    
    var ref: DatabaseReference! {
                get {
                    return _ref
                } set {
                    _ref = newValue
                }
            }
    
    init(UserID: String, Username:String){
        self.userID = UserID
        self.username = Username
    }
    
    func addfavourite(Manga:Manga){
        self.favourites.append(Manga)
    }
    
    
}
