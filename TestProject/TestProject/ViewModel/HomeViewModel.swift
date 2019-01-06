//
//  HomeViewModel.swift
//  TestProject
//
//  Created by wooqer on 05/01/19.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit

class HomeViewModel: NSObject {
    var homeModels : [HomeModel] = []
    
    func fetchData(completionBlock :  @escaping Constant.CompletionBlock){
        ApiManager.sharedInstance.fetchSaleData { (json, error) in
            if error == nil {
                let array  = json?["data"] as! [[String : Any]]
                self.homeModels.removeAll()
                for data in array{
                    let homeModel = HomeModel()
                    homeModel.parseDict(dict: data)
                    self.homeModels.append(homeModel);
                }
            }
            DispatchQueue.main.async {
                completionBlock(json, error)
            }
        }
    }
}
