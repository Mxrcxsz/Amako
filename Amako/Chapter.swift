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
}
