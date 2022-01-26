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
        var url : String = "https://api.mangadex.org/at-home/server/" + "28b5ed48-0dc3-4484-a0df-6d7f0063bdff"
        var request : NSMutableURLRequest = NSMutableURLRequest()
        request.url = URL(string: url)
        request.httpMethod = "GET"

        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue(), completionHandler:{ (response:URLResponse!, data: Data!, error: Error!) in
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject] {
                    //print(jsonResult)
                    print(jsonResult["chapter"])
                    
//                    for result in jsonResult {
//                            print(result)
//                    }
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }


        })
    }
}
