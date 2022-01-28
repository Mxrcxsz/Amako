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
    var list:[String]=[]
    var mangaID:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mangaCollectionView.reloadData() //refresh data
        mangaCollectionView.dataSource = self
        mangaCollectionView.delegate = self
        searchBar.delegate = self
        list = ["0d545e62-d4cd-4e65-a65c-a5c46b794918","72d1ae71-4391-4bb2-9f39-784af3cc3c71","1044287a-73df-48d0-b0b2-5327f32dd651","0d89de3b-454b-422e-9eed-c17402cf1604","7a9d76c3-42b9-4bcf-81d7-ad307d2ea971"]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.mangaCollectionView.reloadData()
    }
    
    private func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mangaCell", for: indexPath) as! searchMangaViewCell
        let url = URL(string: "https://uploads.mangadex.org/covers/1044287a-73df-48d0-b0b2-5327f32dd651/b625ddac-757c-44a4-a392-b315ccdf4fb2.jpg")
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        cell.mangaImg.image = UIImage(data: data!)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        mangaID = list[indexPath.row]
        mc.addToReadHistory(mangaID: mangaID!)
    }
}
