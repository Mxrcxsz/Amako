//
//  MangaController.swift
//  Amako
//
//  Created by Amosy . on 28/1/22.
//

import Foundation
import FirebaseDatabase

class MangaController{
    var appDelegate = (UIApplication.shared.delegate) as! AppDelegate
    var ref: DatabaseReference! =  Database.database().reference()
    
    func retrieveFavouriteMangaList() -> [Manga]
    {
        var favMangaList:[Manga] = []
        
        return favMangaList
    }
}
