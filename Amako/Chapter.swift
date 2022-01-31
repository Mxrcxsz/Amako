//
//  Chapter.swift
//  Amako
//
//  Created by Khim Chua on 1/2/22.
//

import Foundation

class Chapter{
    var chapterID:String
    var chapterNo:String
    var title:String?
    var chapterHash:String?
    var pageList:[String] = []
    
    init(ChapterID:String, Title:String, ChapterNo:String){
        self.chapterID = ChapterID
        self.title = Title
        self.chapterNo = ChapterNo
    }
    
    func getPageList(){
        let urlPath = "https://api.mangadex.org/at-home/server/" + chapterID
        let url = URL(string: urlPath)!
        let session = URLSession.shared

        session.dataTask(with: url){ data, response, error in
           guard let data = data, error == nil else {
                print(error!.localizedDescription)
                return
            }
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]{
                    let pageList = jsonResult["chapter"]
                    let shittychapterHash = pageList!["hash"] as! String
                    let shittypageList = pageList!["data"] as! [String]
                    
                    for i in shittypageList{
                        self.pageList.append(i)
                    }
                    self.chapterHash = shittychapterHash
                    //print(self.chapterHash)
                }
            } catch let parseError {
                print("JSON Error \(parseError.localizedDescription)")
            }
            DispatchQueue.main.sync {
//
            }
        }.resume()
    }
}
