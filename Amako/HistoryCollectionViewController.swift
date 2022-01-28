//
//  HistoryCollectionViewController.swift
//  Amako
//
//  Created by Amosy . on 28/1/22.
//

import UIKit

class HistoryCollectionViewController: UICollectionViewController {
    
    var historyList:[String] = []
    var mc = MangaController()
    override func viewDidLoad() {
        super.viewDidLoad()
        historyList = mc.retrieveReadHistory()
        self.collectionView.reloadData()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
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
        let url = URL(string: "https://uploads.mangadex.org/covers/1044287a-73df-48d0-b0b2-5327f32dd651/b625ddac-757c-44a4-a392-b315ccdf4fb2.jpg")
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        cell.mangaImg.image = UIImage(data: data!)
        cell.labelFld.text = historyList[indexPath.row]
        return cell
    }
    
    @IBAction func deleteBtn(_ sender: Any) {
        let alertView = UIAlertController(title: "Confirm", message: "Delete read history?", preferredStyle: UIAlertController.Style.alert)
        
        alertView.addAction(UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: { _ in
//            self.mc.deleteReadHistory()
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
}
