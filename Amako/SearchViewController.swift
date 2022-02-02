//
//  MangaSearchViewController.swift
//  Amako
//
//  Created by Amosy . on 27/1/22.
//

import UIKit

class MangaSearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var mangaCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var mc = MangaController()
    var mangaResultList:[Manga]=[]
    var appDelegate:AppDelegate?
    var waiting:Bool?
    var index : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        mangaCollectionView.reloadData() //refresh data
        mangaCollectionView.dataSource = self
        mangaCollectionView.delegate = self
        searchBar.delegate = self
        waiting = false
        
        if searchBar.text! == ""{
            searchManga(mangaName: searchBar.text!)
        }
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mangaCell", for: indexPath) as! SearchMangaViewCell
        let manga = mangaResultList[indexPath.row]
        if(manga.coverUrl != nil){
            cell.mangaImg.downloaded(from: manga.coverUrl!)
        }
        cell.mangaTitle.text = manga.title
        cell.mangaStatus.text = manga.status
//        cell.mangaImg.image = UIImage(data: data!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        index = indexPath.row
        performSegue(withIdentifier: "clickedManga", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "clickedManga"{
            let vc = segue.destination as? DetailsViewController
            vc?.manga = mangaResultList[index]
        }
    }
    
//  MARK: Api calling functions
//  search Manga
    func searchManga(mangaName:String){
        let manganame = mangaName.replacingOccurrences(of: " ", with: "%20")
        print("Name: " + manganame)
        var urlPath = "https://api.mangadex.org/manga?title=" + manganame
//      adding more search params
        urlPath += "&availableTranslatedLanguage[]=en&limit=50"
        let url = URL(string: urlPath)!
        let session = URLSession.shared

        session.dataTask(with: url){ data, response, error in
           guard let data = data, error == nil else {
                print(error!.localizedDescription)
                return
            }
            do {
                if let jsonResult = try MangaRootObject.init(data: data) as MangaRootObject?{
                    if jsonResult.data.count >= 1{
                        self.mangaResultList.removeAll()
                        for mangaModel in jsonResult.data{
                            self.mangaResultList.append(Manga(MangaID: mangaModel.id, Title: mangaModel.attributes.title.en, Description: mangaModel.attributes.description.value() as! String, Status: mangaModel.attributes.status.rawValue))
                            self.mangaResultList[self.mangaResultList.count-1].getCoverArtURL()
                            self.waiting = false
                            self.mangaCollectionView.setContentOffset(CGPoint(x:0,y:0), animated: true)
                        }
                    }
                    else{
                        print("No manga found")
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
            DispatchQueue.main.async {
                self.mangaCollectionView.reloadData()
            }
        }.resume()
    }
}
