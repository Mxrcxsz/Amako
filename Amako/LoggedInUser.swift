//
//  LoggedInUser.swift
//  Amako
//
//  Created by Amosy . on 28/1/22.
//

import Foundation

class LoggedInUser{
    var username:String
    var userID:String
    var emailAddr:String
    
    init(Username: String, UserID: String, EmailAddr: String){
        username = Username
        userID = UserID
        emailAddr = EmailAddr
    }
}
