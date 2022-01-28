//
//  Manga.swift
//  Amako
//
//  Created by Amosy . on 28/1/22.
//

import Foundation

class Manga{
    var mangaID:String?
    var fileName:String?
    
    init(MangaID:String, FileName:String?)
    {
        self.mangaID = MangaID
        self.fileName = FileName
    }
}

