//
//  HistoryCollectionViewController.swift
//  Amako
//
//  Created by Amosy . on 28/1/22.
//

import UIKit

class HistoryCollectionViewController: UICollectionViewController {
    
    var historyList:[Manga] = []
    var mc = MangaController()
    var index : Int = 0
    var waiting:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        historyList = mc.retrieveReadHistory()
        historyList = historyList.reversed()
        self.collectionView.reloadData()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        historyList = mc.retrieveReadHistory()
        historyList = historyList.reversed()
        self.collectionView.reloadData()
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return historyList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mangaCell", for: indexPath) as! HistoryCollectionViewCell
        let manga = historyList[indexPath.row]
        let url = manga.coverUrl
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        cell.mangaImg.image = UIImage(data: data!)
        cell.mangaTitle.text = manga.title
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        waiting = true
        index = indexPath.row
        searchManga(mangaId: historyList[indexPath.row].mangaID)
        self.performSegue(withIdentifier: "clickedManga", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "clickedManga"{
            let vc = segue.destination as? DetailsViewController
            vc?.manga = historyList[index]
        }
    }
    
    @IBAction func deleteBtn(_ sender: Any) {
        let alertView = UIAlertController(title: "Confirm", message: "Delete read history?", preferredStyle: UIAlertController.Style.alert)
        
        alertView.addAction(UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: { _ in
            self.mc.deleteReadHistory()
            self.historyList.removeAll()
            self.collectionView.reloadData()
            self.doneAlert()
        }))
        alertView.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in }))
        
        self.present(alertView, animated: true, completion: nil)
    }
    func doneAlert(){
        let alertView = UIAlertController(title: "Success", message: "Done", preferredStyle: UIAlertController.Style.alert)
        
        alertView.addAction(UIAlertAction(title: "Nice", style: UIAlertAction.Style.default, handler: { _ in }))
        self.collectionView.reloadData()
        self.present(alertView, animated: true, completion: nil)
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
                            for i in self.historyList{
                                if (i.mangaID == mangaModel.id){
                                    i.description = mangaModel.attributes.description.value() as? String
                                    i.title = mangaModel.attributes.title.en ?? "no title"
                                    i.status = mangaModel.attributes.status.rawValue
                                }
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
    }
}
