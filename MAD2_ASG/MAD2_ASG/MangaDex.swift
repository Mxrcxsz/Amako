//
//  MangaDex.swift
//  MAD2_ASG
//
//  Created by Darius Kong on 25/1/22.
//

import UIKit

class MangaDex{
    let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
    
    func GetPages(chapterHash:String){
        var url : String = "https://api.mangadex.org/at-home/server/" + chapterHash
        var request : NSMutableURLRequest = NSMutableURLRequest()
        request.url = URL(string: url)
        request.httpMethod = "GET"

        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue(), completionHandler:{ (response:URLResponse!, data: Data!, error: Error!) in
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject] {
                    //print(jsonResult)
                    let pageList = jsonResult["chapter"]
                    
                    var shittychapterHash = pageList!["hash"]
                    var shittypictureHashList = pageList!["data"]
                    
                    //when getting chapterHash must unwrap twice. Same for pictureHashList
                    //print(shittychapterHash!!)
                    //print(pictureHashList!!)
                    var pictureHashList = Array<String>()
                    var chapterHash = ""
                    
                    pictureHashList = shittypictureHashList!! as! [String]
                    chapterHash = shittychapterHash as! String
                    
                    print(pictureHashList)
                    print(chapterHash)
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        })
    }
}
