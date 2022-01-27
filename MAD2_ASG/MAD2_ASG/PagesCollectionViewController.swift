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
    var chapterHash = "lol"
    var mangadexCon = MangaDex()
    
      override func viewDidLoad() {
        super.viewDidLoad()
        GetPages(mangaChapterHash: "28b5ed48-0dc3-4484-a0df-6d7f0063bdff")
         
        
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
        cell.pictureView.contentMode = .scaleToFill
        cell.pictureView.downloaded(from: imgLinkBuilder(index: indexPath.row))
        
        return cell
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
    func GetPages(mangaChapterHash:String){
        let urlPath = "https://api.mangadex.org/at-home/server/" + mangaChapterHash //"28b5ed48-0dc3-4484-a0df-6d7f0063bdff"
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
                        print(self.chapterHash)
                }
            } catch let parseError {
                print("JSON Error \(parseError.localizedDescription)")
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }.resume()
    }
    
    func imgLinkBuilder(index:Int)->String{
        let urlPath = "https://uploads.mangadex.org/data/" + chapterHash + "/" + pictureHashList[index]
        return urlPath
    }
}
