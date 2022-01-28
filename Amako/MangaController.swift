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
        let userID = "px8yMWNkWIbHtCrBdRILIOH8E5n2"
        var favMangaList:[Manga] = []
        var favMangaIDList:[Any] = []
        ref.child("Users/\(userID)/favourites").observe(.value, with: { snapshot in
            guard let value = snapshot.value as? [String: Any] else{
                return
            }
            print("Value: \(value)")
            favMangaIDList.append(value)
        })
        print(favMangaIDList)
        return favMangaList
    }
}
