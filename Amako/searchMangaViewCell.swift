//
//  searchMangaViewCell.swift
//  Amako
//
//  Created by Amosy . on 28/1/22.
//

import Foundation
import UIKit

class SearchMangaViewCell: UICollectionViewCell{
    @IBOutlet weak var mangaImg: UIImageView!
    @IBOutlet weak var mangaTitle: UILabel!
    @IBOutlet weak var mangaStatus: UILabel!
    
    
    override func prepareForReuse(){
        super.prepareForReuse()
        // Set the cell's imageView's image to nil
        self.mangaImg.image = nil
    }
}


