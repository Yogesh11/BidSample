//
//  ArticleModel.swift
//  TestProject
//
//  Created by Yogesh on 08/12/18..
//  Copyright © 2018 Test. All rights reserved.
//

import UIKit

class ArticleModel: NSObject {
    var titleText : String?
    var descriptionText : String?
    var imageUrl  : URL?
    var clickableUrl : URL?
    var rowID : Int = 0
    func makeModel(json : [String : Any?] , rowid : Int) {
         titleText = json["title"] as?  String
          descriptionText = json["description"] as?  String
        if let url =  json["urlToImage"] as?  String , let url1 = URL.init(string: url){
            imageUrl = url1
        }
        if let url =  json["url"] as?  String , let url1 = URL.init(string: url){
            clickableUrl = url1
        }
        rowID = rowid
        
    }
    
    func makeModelFromFb(article : Article) {
        titleText  = article.title
        descriptionText = article.desc
        if let url = article.urlToImage , let url1 = URL(string: url){
            imageUrl  = url1
        }
        rowID = Int(article.rowId)
        if let url = article.clickableUrl , let url1 = URL(string: url){
           clickableUrl = url1
        }
      
    }
}
