//
//  Manga.swift
//  Amako
//
//  Created by Amosy . on 28/1/22.
//

import Foundation

class Manga{
    var mangaID:String?
    var mangaName:String?
    var fileName:String?
    
    init(MangaID:String, MangaName:String, FileName:String?)
    {
        self.mangaID = MangaID
        self.mangaName = MangaName
        self.fileName = FileName
    }
}

