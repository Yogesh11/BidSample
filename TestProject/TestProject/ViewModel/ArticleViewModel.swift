//
//  ArticleViewModel.swift
//  TestProject
//
//  Created by Yogesh on 08/12/18..
//  Copyright © 2018 Test. All rights reserved.
//

import UIKit

class ArticleViewModel: NSObject {
    var articleStorage : [ArticleModel] = []
    var pageNumber : Int = 1
    var totalRows  : Int = -1
    func loadFromDb(){
        if let data  = DataBaseManager.sharedManager.getEntityByName(entityName: "Article", predicate: nil) as? [Article] {
            for article in data {
                let model = ArticleModel()
                 model.makeModelFromFb(article: article)
                self.articleStorage.append(model)
            }
            pageNumber = (data.count/5)
        }
    }
    
    func loadArticles(callback : @escaping Constant.CompletionBlock) {
        ApiManager.sharedInstance.getArticle(pageSize: 5, pageNumber: pageNumber) { (json, error) in
            if error != nil {
                self.pageNumber = self.pageNumber - 1
            } else{
                if self.pageNumber == 1{
                    self.articleStorage.removeAll()
                }
                if let result = json , let responseJson = result[Constant.JsonKeys.kArticles] as? Array<Any> {
                    self.totalRows = (result[Constant.JsonKeys.ktotalResults] as? Int) ?? self.totalRows
                    var i : Int = 0
                    for data in responseJson {
                        if let articleData = data as? [String : Any] {
                            let model = ArticleModel()
                            model.makeModel(json:articleData, rowid: (i * self.pageNumber))
                            self.articleStorage.append(model)
                            i =  i + 1
                            DataBaseManager.sharedManager.saveArticle(article: model)
                        }
                    }
                    if self.articleStorage.count >=  self.totalRows {
                         self.pageNumber = self.pageNumber - 1
                    }
                }
                
            }
            DispatchQueue.main.async {
                 callback(json, error)
            }
        }
    }
}
