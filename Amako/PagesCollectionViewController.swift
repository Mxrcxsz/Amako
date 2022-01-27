//
//  PagesCoectionViewController.swift
//  ASG Test
//
//  Created by Darius Kong on 26/1/22.
//

import UIKit

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}


class PagesCollectionViewController: UICollectionViewController {
    var pictureHashList = Array<String>()
    var chapterHash = ""
    var currChapter = 1
    var totalRows = 0
    var currRow = 0
    
      override func viewDidLoad() {
        super.viewDidLoad()
        //GetPages(mangaChapterHash: "d1e7f729-634d-4fa0-b93e-6fabcfa745f9")
          getAllChapters(mangaHash: "0d545e62-d4cd-4e65-a65c-a5c46b794918")
         
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return pictureHashList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PageCell", for: indexPath) as! PageCollectionViewCell
        //cell.pictureLbl.text = chapterHash
        //this 2 are needed
        cell.pictureView.contentMode = .scaleToFill
        cell.pictureView.downloaded(from: imgLinkBuilder(index: indexPath.row))
        
        if (totalRows != pictureHashList.count-1){
            totalRows = indexPath.row
        }
        else{
            currRow=indexPath.row
        }

        print("lollol " + String(currRow) + "total " + String(totalRows))
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if currRow == collectionView.numberOfItems(inSection: indexPath.section)-1 {
            self.updateNextSet()
        }
    }

    func updateNextSet(){
        print("On Completetion")
        currChapter+=1
        getAllChapters(mangaHash: "0d545e62-d4cd-4e65-a65c-a5c46b794918")
        DispatchQueue.main.async(execute: collectionView.reloadData)
        totalRows = 0
        currRow = 0
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
    
    //For MangaDex
    func getAllChapters(mangaHash:String){
        let urlPath = "https://api.mangadex.org/chapter?manga=" + mangaHash + "&order[chapter]=asc&translatedLanguage[]=en&offset=0&excludedGroups[]=4f1de6a2-f0c5-4ac5-bce5-02c7dbb67deb&limit=100"
        let url = URL(string: urlPath)!
        let session = URLSession.shared
        var newHashID = ""

        session.dataTask(with: url){ data, response, error in
           guard let data = data, error == nil else {
                print(error?.localizedDescription)
                return
            }
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]{
                    let chaptersList = jsonResult["data"]
                    let correctIndex = self.currChapter-1
                    newHashID = chaptersList![correctIndex]!.value(forKey: "id") as! String
                    print("new hash" + newHashID)
                }
            } catch let parseError {
                print("JSON Error \(parseError.localizedDescription)")
            }
            DispatchQueue.main.async {
                self.GetPages(mangaChapterHash: newHashID)
            }
        }.resume()
    }
    
    func GetPages(mangaChapterHash:String){
        let urlPath = "https://api.mangadex.org/at-home/server/" + mangaChapterHash
        let url = URL(string: urlPath)!
        let session = URLSession.shared

        session.dataTask(with: url){ data, response, error in
           guard let data = data, error == nil else {
                print(error?.localizedDescription)
                return
            }
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]{
                        let pageList = jsonResult["chapter"]
                        let shittychapterHash = pageList!["hash"]
                        let shittypictureHashList = pageList!["data"]
                        
                        self.pictureHashList = shittypictureHashList!! as! [String]
                        self.chapterHash = shittychapterHash as! String
                        //print(self.chapterHash)
                }
            } catch let parseError {
                print("JSON Error \(parseError.localizedDescription)")
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }.resume()
    }
    
    //For MangaDex
    func imgLinkBuilder(index:Int)->String{
        let urlPath = "https://uploads.mangadex.org/data/" + chapterHash + "/" + pictureHashList[index]
        return urlPath
    }
}
