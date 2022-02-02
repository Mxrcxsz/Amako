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
    func addToReadHistory(mangaID:String, mangaTitle:String, mangaImageUrl:URL)
    {
        if (checkMangaExists(mangaID: mangaID) == false){
            let context = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "CDHistory", in: context)!
            
            let history = NSManagedObject(entity: entity, insertInto: context)
            history.setValue(mangaID, forKey: "mangaID")
            history.setValue(mangaTitle, forKey: "mangaTitle")
            history.setValue(mangaImageUrl, forKey: "mangaImageUrl")
            do{
                try context.save()
            } catch let error as NSError{
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
        else{
            var managedHistoryList : [NSManagedObject] = []
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CDHistory")
            fetchRequest.predicate = NSPredicate(format: "ANY mangaID = %@", mangaID)
            do {
                managedHistoryList = try context.fetch(fetchRequest)
                for c in managedHistoryList {
                    context.delete(c)
                    
                let entity = NSEntityDescription.entity(forEntityName: "CDHistory", in: context)!
                
                let history = NSManagedObject(entity: entity, insertInto: context)
                history.setValue(mangaID, forKey: "mangaID")
                history.setValue(mangaTitle, forKey: "mangaTitle")
                history.setValue(mangaImageUrl, forKey: "mangaImageUrl")
                do{
                    try context.save()
                } catch let error as NSError{
                    print("Could not save. \(error), \(error.userInfo)")
                }
                }
            } catch let error as NSError {
                print("Could not fetch. \(error) \(error.userInfo)")
            }

        }
    }
    func retrieveReadHistory()->[Manga]{
        var managedHistoryList : [NSManagedObject] = []
        var historyList:[Manga] = []
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CDHistory")
        do {
            managedHistoryList = try context.fetch(fetchRequest)
            for c in managedHistoryList {
                let mangaID = c.value(forKeyPath: "mangaID") as! String
                let mangaTitle = c.value(forKeyPath: "mangaTitle") as! String
                let mangaImageUrl = c.value(forKeyPath: "mangaImageUrl") as! URL
                let manga:Manga = Manga(MangaID: mangaID, CoverURL: mangaImageUrl, Title: mangaTitle)
                historyList.append(manga)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error) \(error.userInfo)")
        }
        return historyList
    }
    func checkMangaExists(mangaID:String)-> Bool{
        var managedHistoryList : [NSManagedObject] = []
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CDHistory")
        fetchRequest.predicate = NSPredicate(format: "ANY mangaID = %@", mangaID)
        do {
            managedHistoryList = try context.fetch(fetchRequest)
            if managedHistoryList.count == 1{
                return true
            }
        } catch let error as NSError {
            print("Could not fetch. \(error) \(error.userInfo)")
        }
        return false
    }
    
    func deleteReadHistory()
    {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CDHistory")
        let context = appDelegate.persistentContainer.viewContext
        if let result = try? context.fetch(fetchRequest) {
            for object in result {
                context.delete(object)
            }
        }
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not fetch. \(error) \(error.userInfo)")
        }
    }
}
