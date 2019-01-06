//
//  ApiManager.swift
//  ShareChat
//
//  Created by Yogesh on 05/01/19.
//  Copyright © 2019 test. All rights reserved.
//

import UIKit

 /** This class is used to call apis*/
class ApiManager: NSObject {
    static let sharedInstance = ApiManager()
    private lazy var sessionManager: URLSession = {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.urlCache = nil
        /*The timeout interval to use when waiting for additional data. The timer associated with this value is reset whenever new data arrives. When the request timer reaches the specified interval without receiving any new data, it triggers a timeout.*/
        sessionConfig.timeoutIntervalForRequest = TimeInterval(30)
        /*The maximum amount of time that a resource request should be allowed to take. This value controls how long to wait for an entire resource to transfer before giving up. The resource timer starts when the request is initiated and counts until either the request completes or this timeout interval is reached, whichever comes first.*/
        sessionConfig.timeoutIntervalForResource = TimeInterval(60)
        return  URLSession(configuration: sessionConfig) //URLSessionConfiguration.default
    }()

    private override init() {
        super.init()
    }
    
    func doRegister(emailAddress : String ,
                    password     : String ,
                    phoneNumber  : String ,
                    userName     : String ,
                    completionBlock :  @escaping Constant.CompletionBlock){
        let url = Constant.Api.kEndPoint + "register?" + "email=" + emailAddress + "&" + "password=" + password + "&" + "username=" + userName + "&" + "mobile=" + phoneNumber
        makeTask(request:  makeRequest(url: url , methodType: Constant.Api.kGetRequest)) { (json, error) in
            if json != nil {
               self.doLogin(emailAddress: emailAddress, password: password, completionBlock: completionBlock)
            } else{
                completionBlock(json, error)
            }
            
        }
    }
   
    func fetchTrendsData(completionBlock :  @escaping Constant.CompletionBlock){
        makeTask(request:  makeRequest(url: Constant.Api.kEndPoint + "gettrending?limit=10" , methodType: Constant.Api.kGetRequest)) { (json, error) in
            completionBlock(json, error)
        }
    }
    
    func fetchSaleData(completionBlock :  @escaping Constant.CompletionBlock){
        makeTask(request:  makeRequest(url: Constant.Api.kEndPoint + "cars_for_sale/open" , methodType: Constant.Api.kGetRequest)) { (json, error) in
            completionBlock(json, error)
        }
    }
    
    func fetchBidData(carID : String , completionBlock :  @escaping Constant.CompletionBlock){
        makeTask(request:  makeRequest(url: Constant.Api.kEndPoint + "car_bidprice?id=" + carID , methodType: Constant.Api.kGetRequest)) { (json, error) in
            completionBlock(json, error)
        }
    }
    
    func postBid(carID : String ,price : String, completionBlock : @escaping Constant.CompletionBlock){
        makeTask(request:  makeRequest(url: Constant.Api.kEndPoint + "update_bidprice?id=" + carID + "&" + "bidprice=" + price, methodType: Constant.Api.kGetRequest)) { (json, error) in
            completionBlock(json, error)
        }
    }
    
    func doLogin(emailAddress : String , password : String, completionBlock :  @escaping Constant.CompletionBlock){
        let url = Constant.Api.kEndPoint + "login?" + "email=" + emailAddress + "&" + "password=" + password
        makeTask(request:  makeRequest(url: url , methodType: Constant.Api.kGetRequest)) { (json, error) in
            completionBlock(json, error)
        }
    }
    func getArticle(pageSize : Int , pageNumber : Int ,completionBlock :  @escaping Constant.CompletionBlock) {
        makeTask(request:  makeRequest(url: Constant.Api.kEndPoint + "pageSize=" + String(pageSize) + "&page=" + String(pageNumber) , methodType: Constant.Api.kGetRequest)) { (json, error) in
            completionBlock(json, error)
        }
    }
    
    /** makeRequest         : makeRequest for an api.
           * url            : api url.
           * completionBlock: completionBlock which will contain errorObj and json.
     */
    private func makeRequest(url : String, methodType : String) -> URLRequest {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = methodType
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }

    /** makeTask      : makeTask for an api.
        * url            : api url.
        * completionBlock: completionBlock which will contain errorObj and json.
     */
    private func makeTask(request : URLRequest, onCompletion : @escaping Constant.CompletionBlock) {
        sessionManager.dataTask(with: request) { (data, response, error) in
            guard let data  = data , error == nil else{
                onCompletion(nil, self.prepareError(error: error))
                return
            }
            do {
                let json =  try JSONSerialization.jsonObject(with: data)
                if let responseJson  =  json as? [String : AnyObject]{
                    if responseJson[Constant.JsonKeys.kStatus] as? Int == 1 {
                        onCompletion(responseJson as AnyObject ,  nil)
                    } else{
                        onCompletion(nil ,  self.prepareErrorWithMessage(errorMessage: responseJson["message"] as? String))
                    }

                } else{
                    onCompletion(nil, self.prepareError(error: error))
                }
            }
            catch {
                onCompletion(nil, self.prepareError(error: error))
            }
        }.resume()
    }

    /** prepareError      : Prepare error.
        * error           : an error object to intialize SCError object.
     */
    private func prepareError(error : Error?) -> SCError{
        return SCError(error: error)
    }

    /** prepareErrorWithMessage : Prepare error with proper message.
            * errorMessage      : An instance of string. It will be used to show an popup on the screen.
     */
    private func prepareErrorWithMessage(errorMessage : String?) -> SCError {
        return SCError(errorMessage: errorMessage)
    }
}
