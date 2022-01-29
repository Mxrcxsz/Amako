//
//  Manga.swift
//  Amako
//
//  Created by Amosy . on 28/1/22.
//

import Foundation

class Favourite{
    var mangaID:String?
    var fileName:String?
    var coverUrl:URL?
    
    
//  For Firebase
    init(MangaID:String, FileName:String?)
    {
        self.mangaID = MangaID
        self.fileName = FileName
    }
    
    func getCoverArtURL(){
    //      Building api url
        let urlPath = "https://api.mangadex.org/cover?manga[]=" + self.mangaID!
        let url = URL(string: urlPath)!
        let session = URLSession.shared

        session.dataTask(with: url){ data, response, error in
           guard let data = data, error == nil else {
                print(error!.localizedDescription)
                return
            }
            do {
                let outputString = String(data: data, encoding: String.Encoding.utf8) as String?
//                print(outputString!)
                if let jsonResult = try CoverRootObject.init(outputString!, using: .utf8) as CoverRootObject?{
                    let coverArtList = jsonResult.data
                    if coverArtList.count > 1{
                        self.fileName = coverArtList[0].attributes.fileName
                        let coverArtUrl = "https://uploads.mangadex.org/covers/" + self.mangaID! + "/" + self.fileName!
                        self.coverUrl = URL(string: coverArtUrl)
                    }
                    else{
                        print("No cover art for following manga")
                    }
                }
            } catch let parseError {
                print("JSON Error \(parseError.localizedDescription)")
            }
            DispatchQueue.main.sync {
//                print(coverUrl)
            }
        }.resume()
    }
}

