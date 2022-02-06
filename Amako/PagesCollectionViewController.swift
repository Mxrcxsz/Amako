//
//  PagesCoectionViewController.swift
//  ASG Test
//
//  Created by Darius Kong on 26/1/22.
//

import UIKit
import CoreData

class PagesCollectionViewController: UICollectionViewController {
    var pageList = Array<String>()
    var chapterIDList = Dictionary<Int,String>()
    var chapterHash = ""
    var nextchapterHash = ""
    var currChapter = 1
    var currPage = 0
    var firstCheck = 0
    var offset = 0
    var realChap = 0
    var totalResult = 0
    var canLoad = true
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    
    override func viewDidLoad() {
        super.viewDidLoad()
        currChapter = appDelegate.selectedChapNo!
        //print("chapter", currChapter)
        realChap = appDelegate.selectedChapNo!
        totalResult = appDelegate.totalResult!
        
        if currChapter > 100 && currChapter < 200{
            offset = 99
            currChapter -= 99
        }
        else if currChapter >= 200{
            offset = 199
            currChapter -= 199
        }
        
        getAllChapters(mangaID: appDelegate.selectedMangaId!)
                
        //print("offset", offset, "currchap", currChapter)
        //print("Chapter number:", appDelegate.selectedChapNo!, "MangaID:", appDelegate.selectedMangaId!)

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
        print("CurrPage", indexPath.row)
        
//        if firstCheck != pageList.count-1{
//            firstCheck = indexPath.row
//        }
//        else{
            currPage = indexPath.row
//        }
        
        //print("Current page is " + String(currPage) + " Stupid Index is " + String(indexPath.row))
        return cell
    }
    
    override func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        let actualPosition = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        if (actualPosition.y < 0){
            // Dragging down
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        else{
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset + 90
//        print(height)
//        print(distanceFromBottom + 60)

        if distanceFromBottom + 60 < height && currPage != 0 && canLoad && currChapter <= chapterIDList.count{
            if realChap < totalResult{
                canLoad = false
                currChapter+=1
                realChap += 1

                if realChap > 100 && realChap < 200{
                    offset = 99
                    currChapter = realChap - 99
                }
                else if realChap >= 200{
                    offset = 199
                    currChapter = realChap - 199
                }
                self.updateNextSet()
                currPage = 0
            }
            else{
                showToast(message: "Last Chapter", font: .systemFont(ofSize: 12.0))
            }
        }
        else if distanceFromBottom > scrollView.contentSize.height + 210 && canLoad{
            if realChap != 1{
                canLoad = false
                currChapter-=1
                realChap -= 1
                
                if realChap <= 100{
                    offset = 0
                    currChapter = realChap
                }
                else if realChap > 100 && realChap < 200{
                    offset = 99
                    currChapter = realChap - 99
                }
                else if realChap >= 200{
                    offset = 199
                    currChapter = realChap - 199
                }
                
               self.updatePreviousSet()
               currPage = 0
            }
            else{
                showToast(message: "First Chapter", font: .systemFont(ofSize: 12.0))
            }
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.frame.size.width/3.5, height: collectionView.frame.size.height/4)
//    }

        
    func updateNextSet(){
        getAllChapters(mangaID: appDelegate.selectedMangaId!)
        DispatchQueue.main.async(execute: collectionView.reloadData)
        self.collectionView.setContentOffset(CGPoint(x:0,y:0), animated: true)
        currPage = 0
        firstCheck = 0
        pageList.removeAll()
    }
    
    func updatePreviousSet(){
        getAllChapters(mangaID: appDelegate.selectedMangaId!)
        DispatchQueue.main.async(execute: collectionView.reloadData)
        currPage = 0
        firstCheck = 0
        self.collectionView.scrollToItem(at: NSIndexPath(row: pageList.count-1, section: 0) as IndexPath, at: .bottom, animated: true)
        pageList.removeAll()
    }
    
    //For MangaDex
    func getAllChapters(mangaID:String){
        print("offset", offset, "currChap", currChapter, "realChap", realChap)
        let urlPath = "https://api.mangadex.org/chapter?manga=" + mangaID + "&order[chapter]=asc&translatedLanguage[]=en&offset=" + String(offset) + "&excludedGroups[]=4f1de6a2-f0c5-4ac5-bce5-02c7dbb67deb&limit=100"
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
    
    func showToast(message : String, font: UIFont) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.gray.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 18;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
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
}

