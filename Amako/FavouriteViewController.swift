//
//  FavouriteMangaViewController.swift
//  Amako
//
//  Created by Amosy . on 27/1/22.
//

import UIKit
import FirebaseDatabase

private let reuseIdentifier = "Cell"

class FavouriteMangaViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    var mc = MangaController()
    var mangaResultList:[Manga]=[]
    var waiting:Bool?
    var index : Int = 0
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.mangaResultList.removeAll()
        for i in appDelegate.user.favourites{
            searchManga(mangaId: i.mangaID)
        }
        self.collectionView.reloadData()
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return appDelegate.user.favourites.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mangaCell", for: indexPath) as! FavouriteMangaViewCell
        let url = appDelegate.user.favourites[indexPath.row].coverUrl
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        cell.favMangaImage.image = UIImage(data: data!)
        cell.favMangaTitle.text = appDelegate.user.favourites[indexPath.row].title
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        index = indexPath.row
        searchManga(mangaId: appDelegate.user.favourites[indexPath.row].mangaID)
        self.performSegue(withIdentifier: "clickedFavManga", sender: self)
        print("index", index)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "clickedFavManga"{
            let vc = segue.destination as? DetailsViewController
            vc?.manga = mangaResultList[index]
        }
    }
    
    func searchManga(mangaId:String){
        var urlPath = "https://api.mangadex.org/manga?availableTranslatedLanguage[]=en&ids[]="
//      adding more search params
        urlPath += mangaId
        let url = URL(string: urlPath)!
        print("url", url)
        let session = URLSession.shared

        session.dataTask(with: url){ data, response, error in
           guard let data = data, error == nil else {
                print(error!.localizedDescription)
                return
            }
            do {
                if let jsonResult = try MangaRootObject.init(data: data) as MangaRootObject?{
                    if jsonResult.data.count >= 1 {
                        for mangaModel in jsonResult.data{
                            self.mangaResultList.append(Manga(MangaID: mangaModel.id, Title: mangaModel.attributes.title.en, Description: mangaModel.attributes.description.value() as! String, Status: mangaModel.attributes.status.rawValue))
                            self.mangaResultList[self.mangaResultList.count-1].getCoverArtURL()
                        }
                        for i in self.appDelegate.user.favourites{
                            if (i.mangaID == self.mangaResultList[self.mangaResultList.count-1].mangaID){
                                self.mangaResultList[self.mangaResultList.count-1].coverUrl = i.coverUrl
                            }
                        }
                    }
                }
            }
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
        }.resume()
        DispatchQueue.main.async {
            print("list", self.mangaResultList)
        }
    }
}
