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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mangaCollectionView.reloadData() //refresh data
        mangaCollectionView.dataSource = self
        mangaCollectionView.delegate = self
        searchBar.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.mangaCollectionView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
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
        print("tapped")
    }
}
