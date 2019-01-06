//
//  DetailViewModel.swift
//  TestProject
//
//  Created by wooqer on 05/01/19.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit

class DetailViewModel: NSObject {
    weak var model : HomeModel?
    func fetchDataWithCarID( completionBlock :  @escaping Constant.CompletionBlock) {
        if let model1 = model {
            ApiManager.sharedInstance.fetchBidData(carID: String(model1.saleID)) { (json, error) in
                if let responseJson = json {
                    if let bidPrice =  responseJson["price"] as? String {
                        self.model?.bidPrice = bidPrice
                    }
                }
                DispatchQueue.main.async {
                    completionBlock(json, error)
                }
            }
        }
        
    }
    
    func postBid(price : String , completionBlock : @escaping Constant.CompletionBlock){
        var prVal : Int = 0
        if let previousVal = Float(model?.bidPrice ?? "0") {
            prVal = Int(previousVal)
        }
        
    //  let previousVal =  Int(Float(floatstring)!)
        if price.isEmpty == false , let val = Int(price), val > prVal {
            ApiManager.sharedInstance.postBid(carID: String(model!.saleID), price:  price) { (json, error) in
                DispatchQueue.main.async {
                    completionBlock(json, error)
                }
            }
        } else{
            let error = SCError.init(errortitle: "", errorMessage: "Amount should be greater than current bid", errorCode: "1111")
            completionBlock(nil,error)
        }
    }
}
