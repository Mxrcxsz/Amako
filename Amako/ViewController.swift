//
//  ViewController.swift
//  Amako
//
//  Created by Khim Chua on 27/1/22.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var pageList = Array<String>()
    var chapterIDList = Dictionary<Int,String>()
    var chapterHash = ""
    var nextchapterHash = ""
    var currChapter = 1
    var currPage = 0
    var firstCheck = 0
    var canLoad = true
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("Chapter number:", appDelegate.selectedChapNo!, "MangaID:", appDelegate.selectedMangaId!)
        getAllChapters(mangaID: appDelegate.selectedMangaId!)
        currChapter = appDelegate.selectedChapNo!
        
        let layout = collectionView.collectionViewLayout
        if let flowLayout = layout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(
                width: collectionView.widestCellWidth,
                // Make the height a reasonable estimate to
                // ensure the scroll bar remains smooth
                height: 700
            )
        }
    }

    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return pageList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PageCell", for: indexPath) as! PageCollectionViewCell
        //this 2 are needed
        cell.pictureView.contentMode = .scaleToFill
        cell.pictureView.downloaded(from: imgLinkBuilder(index: indexPath.row))
        
//        if firstCheck != pageList.count-1{
//            firstCheck = indexPath.row
//        }
//        else{
            currPage = indexPath.row
//        }
        
        //print("Current page is " + String(currPage) + " Stupid Index is " + String(indexPath.row))
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset + 90
//        print(height)
//        print(distanceFromBottom + 60)

        if distanceFromBottom + 60 < height && currPage != 0 && canLoad && currChapter <= chapterIDList.count{
            print("fetching more pages")
           canLoad = false
           currChapter+=1
           self.updateNextSet()
           currPage = 0
        }
        else if distanceFromBottom > scrollView.contentSize.height + 210 && currChapter != 1{
            print("fetching more pages")
           canLoad = false
           currChapter-=1
           self.updatePreviousSet(float: scrollView.contentSize.height)
           currPage = 0
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.frame.size.width/3.5, height: collectionView.frame.size.height/4)
//    }

        
    func updateNextSet(){
        print("current chapter " + String(currChapter))
        getAllChapters(mangaID: appDelegate.selectedMangaId!)
        DispatchQueue.main.async(execute: collectionView.reloadData)
        self.collectionView.setContentOffset(CGPoint(x:0,y:0), animated: true)
        currPage = 0
        firstCheck = 0
        pageList.removeAll()
    }
    
    func updatePreviousSet(float: CGFloat){
        print("current chapter " + String(currChapter))
        getAllChapters(mangaID: appDelegate.selectedMangaId!)
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
                    //print(self.chapterIDList.count)
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

