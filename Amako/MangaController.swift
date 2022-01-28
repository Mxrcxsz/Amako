//
//  MangaController.swift
//  Amako
//
//  Created by Amosy . on 28/1/22.
//

import Foundation
import FirebaseDatabase
import CoreData

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
    func addToReadHistory(mangaID:String)
    {
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "CDHistory", in: context)!
        
        let history = NSManagedObject(entity: entity, insertInto: context)
        history.setValue(mangaID, forKey: "mangaID")
        do{
            try context.save()
        } catch let error as NSError{
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    func retrieveReadHistory()->[String]{
        var managedHistoryList : [NSManagedObject] = []
        var historyList:[String] = []
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CDHistory")
        do {
            managedHistoryList = try context.fetch(fetchRequest)
            for c in managedHistoryList {
                let mangaID = c.value(forKeyPath: "mangaID") as! String
                historyList.append(mangaID)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error) \(error.userInfo)")
        }
        return historyList
    }
}
