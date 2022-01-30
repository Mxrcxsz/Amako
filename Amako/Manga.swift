//
//  Manga.swift
//  Amako
//
//  Created by Amosy . on 28/1/22.
//

import Foundation

class Manga{
    var mangaID:String
    var title:String?
    var description:String?
    var status:String?
    var coverUrl:URL?
//    var chapterList:[Chapter] = []
    
    init(MangaID:String, Title:String, Description:String, Status:String){
        self.mangaID = MangaID
        self.title = Title
        self.description = Description
        self.status = Status
    }
    
    
//  Fetch from Firebase
    init(MangaID:String, CoverURL:String)
    {
        self.mangaID = MangaID
        self.coverUrl = URL(string: CoverURL)
    }
    
    func getCoverArtURL(){
    //      Building api url
        let urlPath = "https://api.mangadex.org/cover?manga[]=" + self.mangaID
        let url = URL(string: urlPath)!
        let session = URLSession.shared

        session.dataTask(with: url){ data, response, error in
           guard let data = data, error == nil else {
                print(error!.localizedDescription)
                return
            }
            do {
                if let jsonResult = try CoverRootObject(data: data) as CoverRootObject?{
                    let coverArtList = jsonResult.data
                    if coverArtList.count > 1{
                        let coverArtUrl = "https://uploads.mangadex.org/covers/" + self.mangaID + "/" + coverArtList[0].attributes.fileName
                        self.coverUrl = URL(string: coverArtUrl)
                    }
                    else{
                        print("No cover art for following manga")
                    }
                }
            } catch let parseError {
                print("Cover Art JSON Error \(parseError.localizedDescription)")
            }
            DispatchQueue.main.sync {
//                print(coverUrl)
            }
        }.resume()
    }
}

