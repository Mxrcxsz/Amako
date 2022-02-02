//
//  DetailsViewController.swift
//  Amako
//
//  Created by Khim Chua on 31/1/22.
//

import UIKit
import FirebaseDatabase

class DetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var manga:Manga?
    var totalResult = 0
    var limit = 100
    var offset = 0
    var isLabelAtMaxHeight = false
    var chapterList:[Chapter]=[]
    var waiting = false
    var isFavourite = false
    var iconName = "like"
    var appDelegate:AppDelegate?
    var mangaController = MangaController()
    var ref:DatabaseReference!
    
    @IBOutlet weak var mangaImg: UIImageView!
    @IBOutlet weak var titleTxt: UILabel!
    @IBOutlet weak var statusTxt: UILabel!
    @IBOutlet weak var descriptionTxt: UILabel!
    @IBOutlet weak var lblHeight: NSLayoutConstraint!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var readMoreBtn: UIButton!
    @IBOutlet weak var favouriteBtn: UIButton!
    @IBOutlet weak var chapterTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        chapterTableView.dataSource = self
        chapterTableView.delegate = self
        getAllChapters(manga: manga!, offset: offset)
        waiting = true
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        mangaController.addToReadHistory(mangaID: manga!.mangaID, mangaTitle: manga!.title!, mangaImageUrl: manga!.coverUrl!)
        ref = Database.database().reference()
        
//      Display labels
        if manga?.coverUrl != nil {
            let data = try? Data(contentsOf: (manga?.coverUrl)!)
            mangaImg.image = UIImage(data: data!)
        }
        titleTxt.text = manga?.title
        statusTxt.text = manga?.status
        descriptionTxt.text = manga?.description
        
        for favManga in appDelegate!.user.favourites{
            if(favManga.mangaID == manga?.mangaID){
                iconName = "like-fill"
                isFavourite = true
            }
        }
        let toggleImage = UIImage(named: iconName)! as UIImage
        favouriteBtn.setImage(toggleImage, for: UIControl.State.normal)
    }
    
    @IBAction func toggleFavourite(_ sender: Any) {
        var user = appDelegate!.user
        if isFavourite{
            for i in user.favourites{
                if(i.mangaID == manga?.mangaID){
//                  Get found manga's index in user's favourite list
                    let favMangaIndex = user.favourites.firstIndex(where: {$0 === i})
                    print(favMangaIndex!)
                    user.favourites.remove(at: favMangaIndex!)
                }
            }
            isFavourite = false
            iconName = "like"
        }
        else{
            user.addfavourite(favouriteManga: Manga(MangaID: manga!.mangaID, CoverURL: manga!.coverUrl!.absoluteString, Title: manga!.title!))
            isFavourite = true
            iconName = "like-fill"
        }
        let toggleImage = UIImage(named: iconName)! as UIImage
        favouriteBtn.setImage(toggleImage, for: UIControl.State.normal)
        
        var dictArray: [Dictionary<String, Any>] = []
        for favourite in user.favourites{
            dictArray.append(["chapter":1,"coverUrl":favourite.coverUrl!.absoluteString, "mangaID":favourite.mangaID, "title":favourite.title!])
        }
        ref.child("Users").child(user.userID).child("Favourites").setValue(dictArray)
    }
    
    @IBAction func readMore(_ sender: Any) {
        if isLabelAtMaxHeight {
            readMoreBtn.setTitle("Read more", for: .normal)
                isLabelAtMaxHeight = false
            
            viewHeight.constant -= lblHeight.constant
                lblHeight.constant = 70
            }
            else {
                readMoreBtn.setTitle("Read less", for: .normal)
                isLabelAtMaxHeight = true
                let labelHeight = getLabelHeight(text: descriptionTxt.text!, width: view.bounds.width, font: descriptionTxt.font)
                lblHeight.constant = labelHeight
                viewHeight.constant += labelHeight
            }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chapterList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chapterCell", for: indexPath)
        cell.textLabel?.text = chapterList[indexPath.row].title
        cell.detailTextLabel?.text = "Chapter " + chapterList[indexPath.row].chapterNo
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("Chapter number:", indexPath.row, "MangaID:", (manga?.mangaID)!)
        appDelegate!.selectedChapNo = indexPath.row + 1
        appDelegate!.selectedMangaId = (manga?.mangaID)!
    }
    
    func getLabelHeight(text: String, width: CGFloat, font: UIFont) -> CGFloat {
        let lbl = UILabel(frame: .zero)
        lbl.frame.size.width = width
        lbl.font = font
        lbl.numberOfLines = 0
        lbl.text = text
        lbl.sizeToFit()

        return lbl.frame.size.height
    }
    
//  Fetch chapters
    //For MangaDex
    func getAllChapters(manga:Manga, offset:Int){
        let urlPath = "https://api.mangadex.org/chapter?manga=" + manga.mangaID + "&order[chapter]=asc&translatedLanguage[]=en&offset=" + String(offset) + "&excludedGroups[]=4f1de6a2-f0c5-4ac5-bce5-02c7dbb67deb&limit=100"
        let url = URL(string: urlPath)!
        let session = URLSession.shared

        session.dataTask(with: url){ data, response, error in
           guard let data = data, error == nil else {
                print(error!.localizedDescription)
                return
            }
            do {
                if let jsonResult = try ChapterRootObject.init(data: data) as ChapterRootObject?{
                    self.totalResult = jsonResult.total
                    if jsonResult.data.count >= 1{
                        for chapter in jsonResult.data{
                            self.chapterList.append(Chapter(ChapterID: chapter.id, Title: chapter.attributes.title ?? "", ChapterNo: chapter.attributes.chapter ?? ""))
                        }
                        self.waiting = false
                    }
                    else{
                        print("No chapter found")
                        print(self.chapterList.count)
                    }
                }
            } catch let DecodingError.dataCorrupted(context) {
                print(context)
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.typeMismatch(type, context)  {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch {
                print("error: ", error)
            }
            DispatchQueue.main.sync {
                self.chapterTableView.reloadData()
                self.loadMoreChapters()
            }
        }.resume()
    }

    func loadMoreChapters(){
        if totalResult > limit && waiting == false{
            offset += 100
            getAllChapters(manga: manga!, offset: offset)
            waiting = true
        }
    }
}
