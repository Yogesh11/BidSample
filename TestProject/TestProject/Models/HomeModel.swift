//
//  HomeModel.swift
//  TestProject
//
//  Created by Yogesh on 05/01/19.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit

class HomeModel: NSObject {
    var carUrl     : String?
    var modelName  : String!
    var year       : String!
    var mileage    : String!
    var saleID     : Int! = 0
    var basePrice  : String!   = "200000"
    var bidPrice   : String!   = "1"
    var bidStartTime : String!
    func parseDict(dict : [String : Any]) {
        modelName     = (dict["model"] as? String) ?? "Swift"
        year          = (dict["manufacturedyear"] as? String) ?? "2008"
        mileage       = (dict["milleage"] as? String) ?? "12"
        saleID        = (dict["cars_for_sale_id"] as? Int) ?? 0
        basePrice     = (dict["baseprice"] as? String) ?? "200000"
        carUrl        = (dict["imageurl"] as? String)
        bidPrice      = (dict["bidprice"] as? String) ?? basePrice
        bidStartTime  =  dict["bidstarttime"] as? String
      //  bidStartTime = UTCToLocal(date: <#T##String#>)
       // getTimeDifferenceInMinutes()
     }
    
//    func UTCToLocal(date:String) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "H:mm:ss"
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
//
//        let dt = dateFormatter.date(from: date)
//        dateFormatter.timeZone = TimeZone.current
//        dateFormatter.dateFormat = "h:mm a"
//
//        return dateFormatter.string(from: dt!)
//    }
//
    func getTimeDifferenceInMinutes()-> Date{
       // 2019-01-05 23:45:01.513847
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.S"
//        formatter.locale = NSLocale(localeIdentifier: "en_US") as Locale!
         // formatter.timeZone = TimeZone.current
         let date = formatter.date(from: bidStartTime) as! Date
         return date
    }
    
    
}
