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
    
    init(UserID: String, Username:String){
        self.userID = UserID
        self.username = Username
    }
    
    func addfavourite(Manga:Manga){
        self.favourites.append(Manga)
    }
    
    
}
