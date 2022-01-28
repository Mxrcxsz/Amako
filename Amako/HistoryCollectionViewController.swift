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

        // Do any additional setup after loading the view.
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func viewDidAppear(_ animated: Bool) {
        self.collectionView.reloadData()
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
        return cell
    }
}
