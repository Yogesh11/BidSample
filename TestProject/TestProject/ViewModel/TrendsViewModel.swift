//
//  TrendsViewModel.swift
//  TestProject
//
//  Created by Yogesh on 06/01/19.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit

class TrendsViewModel: NSObject {
    var trendsModel : [HomeModel] = []
    
    func fetchData(completionBlock :  @escaping Constant.CompletionBlock){
        ApiManager.sharedInstance.fetchTrendsData { (json, error) in
            if error == nil {
                let array  = json?["data"] as! [[String : Any]]
                self.trendsModel.removeAll()
                for data in array{
                    let homeModel = HomeModel()
                    homeModel.parseDict(dict: data)
                    self.trendsModel.append(homeModel);
                }
            }
            DispatchQueue.main.async {
                completionBlock(json, error)
            }
        }
    }
}
