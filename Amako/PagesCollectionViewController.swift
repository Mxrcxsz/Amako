//
//  PagesCoectionViewController.swift
//  ASG Test
//
//  Created by Darius Kong on 26/1/22.
//

import UIKit


class PagesCollectionViewController: UICollectionViewController, UIGestureRecognizerDelegate {
    var pageList = Array<String>()
    var chapterIDList = Dictionary<Int,String>()
    var chapterHash = ""
    var nextchapterHash = ""
    var currChapter = 1
    var currPage = 0
    var firstCheck = 0
    var canLoad = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllChapters(mangaID: "1044287a-73df-48d0-b0b2-5327f32dd651")
        print("current chapter " + String(currChapter))
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
        cell.pictureView.downloaded(from: imgLinkBuilder(index: indexPath.row))
        
        if firstCheck != pageList.count-1{
            firstCheck = indexPath.row
        }
        else{
            currPage = indexPath.row
        }
        
        //print("Current page is " + String(currPage) + " Stupid Index is " + String(indexPath.row))
        return cell
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset + 90
        print(scrollView.contentOffset.y)

        if distanceFromBottom < height && currPage != 0 && canLoad{
            print("fetching more pages")
           canLoad = false
           currChapter+=1
           self.updateNextSet()
           currPage = 0
        }
        else if distanceFromBottom - 250 > scrollView.contentSize.height && currChapter != 1{
            print("fetching more pages")
           canLoad = false
           currChapter-=1
           self.updatePreviousSet(float: scrollView.contentSize.height)
           currPage = 0
        }
    }
        
    func updateNextSet(){
        print("current chapter " + String(currChapter))
        getAllChapters(mangaID: "1044287a-73df-48d0-b0b2-5327f32dd651")
        DispatchQueue.main.async(execute: collectionView.reloadData)
        self.collectionView.setContentOffset(CGPoint(x:0,y:0), animated: true)
        currPage = 0
        firstCheck = 0
        pageList.removeAll()
    }
    
    func updatePreviousSet(float: CGFloat){
        print("current chapter " + String(currChapter))
        getAllChapters(mangaID: "1044287a-73df-48d0-b0b2-5327f32dd651")
        DispatchQueue.main.async(execute: collectionView.reloadData)
        currPage = 0
        firstCheck = 0
        pageList.removeAll()
    }
    
    //For MangaDex
    func getAllChapters(mangaID:String){
        let urlPath = "https://api.mangadex.org/chapter?manga=" + mangaID + "&order[chapter]=asc&translatedLanguage[]=en&offset=0&excludedGroups[]=4f1de6a2-f0c5-4ac5-bce5-02c7dbb67deb&limit=100"
        let url = URL(string: urlPath)!
        let session = URLSession.shared

        session.dataTask(with: url){ data, response, error in
           guard let data = data, error == nil else {
                print(error!.localizedDescription)
                return
            }
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]{
                    let jsonData = jsonResult["data"]
                    var index = 0
                    for chapterID in jsonData!.value(forKey: "id") as! [String]
                    {
                        self.chapterIDList[index] = chapterID
                        //print(self.chapterIDList[index]!)
                        index += 1
                    }
                    print(self.chapterIDList.count)
                }
            } catch let parseError {
                print("JSON Error \(parseError.localizedDescription)")
            }
            DispatchQueue.main.sync {
                self.GetPages(mangaChapterHash: self.chapterIDList[self.currChapter-1]!)
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
                self.canLoad = true
            }
        }.resume()
    }
    
    //For MangaDex
    func imgLinkBuilder(index:Int)->String{
        let urlPath = "https://uploads.mangadex.org/data/" + chapterHash + "/" + pageList[index]
        return urlPath
    }
}

extension UIImageView {
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
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
//    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
//        guard let url = URL(string: link) else { return }
//        downloaded(from: url, contentMode: mode)
//    }
}
