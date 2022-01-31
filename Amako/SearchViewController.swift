//
//  MangaSearchViewController.swift
//  Amako
//
//  Created by Amosy . on 27/1/22.
//

import UIKit
import FirebaseDatabase

class MangaSearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var mangaCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var mc = MangaController()
    var mangaResultList:[Manga]=[]
    var appDelegate:AppDelegate?
    var ref:DatabaseReference!
    var waiting:Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        mangaCollectionView.reloadData() //refresh data
        mangaCollectionView.dataSource = self
        mangaCollectionView.delegate = self
        searchBar.delegate = self
        waiting = false
        ref = Database.database().reference()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.mangaCollectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("before search")
        if(!waiting!){
            print("searching")
            searchManga(mangaName: searchBar.text!)
            waiting = true
        }
    }
    
//  MARK: Collection View Section
    
    private func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mangaResultList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mangaCell", for: indexPath) as! searchMangaViewCell
        let manga = mangaResultList[indexPath.row]
        if(manga.coverUrl != nil){
            cell.mangaImg.downloaded(from: manga.coverUrl!)
        }
        cell.mangaTitle.text = manga.title
        cell.mangaStatus.text = manga.status
//        cell.mangaImg.image = UIImage(data: data!)
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.deselectItem(at: indexPath, animated: true)
//        mangaID = list[indexPath.row]
//        mc.addToReadHistory(mangaID: mangaID!)
//        let user = appDelegate!.user
//        user.addfavourite(favouriteManga: Favourite(MangaID: "0d545e62-d4cd-4e65-a65c-a5c46b794918", FileName: "e4159693-18f3-472d-ba92-a1c96d32d36e.jpg"))
//        var dictArray: [Dictionary<String, Any>] = []
//        for favourite in user.favourites{
//            dictArray.append(["chapter":1,"fileName":favourite.fileName!, "mangaID":favourite.mangaID!])
//        }
//        ref.child("Users").child(user.userID).child("Favourites").setValue(dictArray)
//    }
    
//  MARK: Api calling functions
//  search Manga
    func searchManga(mangaName:String){
        var urlPath = "https://api.mangadex.org/manga?title=" + mangaName
//      adding more search params
        urlPath += "&availableTranslatedLanguage[]=en"
        let url = URL(string: urlPath)!
        let session = URLSession.shared

        session.dataTask(with: url){ data, response, error in
           guard let data = data, error == nil else {
                print(error!.localizedDescription)
                return
            }
            do {
                let outputString = String(data: data, encoding: String.Encoding.utf8) as String?
                if let jsonResult = try MangaRootObject.init(outputString!, using: .utf8) as MangaRootObject?{
                    if jsonResult.data.count > 1{
                        self.mangaResultList.removeAll()
                        for mangaModel in jsonResult.data{
                            self.mangaResultList.append(Manga(MangaID: mangaModel.id, Title: mangaModel.attributes.title.en, Description: mangaModel.attributes.description.value() as! String, Status: mangaModel.attributes.status.rawValue))
                            self.mangaResultList[self.mangaResultList.count-1].getCoverArtURL()
                            print("waiting")
                            self.waiting = false
                        }
                    }
                    else{
                        print("No manga found")
                    }
                }
            }// catch let parseError {
//                print("Search Manga JSON Error \(parseError.localizedDescription)")
//                self.waiting = false
//            }
            catch let DecodingError.dataCorrupted(context) {
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
            DispatchQueue.main.async {
                self.mangaCollectionView.reloadData()
            }
        }.resume()
    }
}
