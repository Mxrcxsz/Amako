//
//  PagesCoectionViewController.swift
//  ASG Test
//
//  Created by Darius Kong on 26/1/22.
//

import UIKit


class PagesCollectionViewController: UICollectionViewController {
    var pageList = Array<String>()
    var chapterHash = ""
    var nextchapterHash = ""
    var currChapter = 1
    var nextChapter = 0
    var totalRows = 0
    var currRow = 0
    var waiting = false
    
      override func viewDidLoad() {
          super.viewDidLoad()
          nextChapter = currChapter + 1
          getAllChapters(mangaID: "0d545e62-d4cd-4e65-a65c-a5c46b794918")
         
    }
    
    //For MangaDex
    func getAllChapters(mangaID:String){
        let urlPath = "https://api.mangadex.org/chapter?manga=" + mangaID + "&order[chapter]=asc&translatedLanguage[]=en&offset=0&excludedGroups[]=4f1de6a2-f0c5-4ac5-bce5-02c7dbb67deb&limit=100"
        let url = URL(string: urlPath)!
        let session = URLSession.shared
        var chapterID = ""

        session.dataTask(with: url){ data, response, error in
           guard let data = data, error == nil else {
                print(error!.localizedDescription)
                return
            }
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]{
                    let chaptersList = jsonResult["data"]
                    let correctIndex = self.currChapter-1
                    chapterID = chaptersList![correctIndex]!.value(forKey: "id") as! String
                    print("Current chapter id: " + chapterID)
                }
            } catch let parseError {
                print("JSON Error \(parseError.localizedDescription)")
            }
            DispatchQueue.main.sync {
                self.GetPages(mangaChapterHash: chapterID)
            }
        }.resume()
    }
    
    func GetPages(mangaChapterHash:String){
        let urlPath = "https://api.mangadex.org/at-home/server/" + mangaChapterHash
        let url = URL(string: urlPath)!
        let session = URLSession.shared

        session.dataTask(with: url){ data, response, error in
           guard let data = data, error == nil else {
                print(error!.localizedDescription)
                return
            }
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]{
                    let pageList = jsonResult["chapter"]
                    let shittychapterHash = pageList!["hash"] as! String
                    let shittypageList = pageList!["data"] as! [String]
                    
                    for i in shittypageList{
                        self.pageList.append(i)
                    }
                    self.chapterHash = shittychapterHash
                    //print(self.chapterHash)
                }
            } catch let parseError {
                print("JSON Error \(parseError.localizedDescription)")
            }
            DispatchQueue.main.sync {
                self.collectionView.reloadData()
                self.waiting = false
            }
        }.resume()
    }
    
    //For MangaDex
    func imgLinkBuilder(index:Int)->String{
        let urlPath = "https://uploads.mangadex.org/data/" + chapterHash + "/" + pageList[index]
        return urlPath
    }
    
    func updateNextSet(){
        print("On Completetion")
        currChapter+=1
        getAllChapters(mangaID: "0d545e62-d4cd-4e65-a65c-a5c46b794918")
        totalRows = 0
        currRow = 0
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return pageList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PageCell", for: indexPath) as! PageCollectionViewCell
        //this 2 are needed
        cell.pictureView.contentMode = .scaleToFill
//         cell.pictureView.downloaded(from: imgLinkBuilder(index: indexPath.row))
        
        if (totalRows != pageList.count-1){
            totalRows = indexPath.row
        }
        else{
            currRow=indexPath.row
        }

        print("lollol " + String(currRow) + "total " + String(totalRows))
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == collectionView.numberOfItems(inSection: indexPath.section)-1 && !waiting {
            print("getting more pages")
            waiting = true
            self.updateNextSet()
        }
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
}

extension UIImageView {
//    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
//        contentMode = mode
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard
//                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
//                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
//                let data = data, error == nil,
//                let image = UIImage(data: data)
//                else { return }
//            DispatchQueue.main.async() { [weak self] in
//                self?.image = image
//            }
//        }.resume()
//    }
//    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
//        guard let url = URL(string: link) else { return }
//        downloaded(from: url, contentMode: mode)
//    }
}
