//
//  Constant.swift
//  ShareChat
//
//  Created by Yogesh on 05/01/19.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

struct Constant {
    struct Api {
        static let kEndPoint  = "http://10.2.41.69:3134/"
        static let kGetRequest = "GET"
    }

    
    struct CellIdentifier {
       
    }

    struct JsonKeys {
        static let kError        = "error"
        static let kdata         = "data"
        static let kStatus       = "status"
      
        
    }
    
    struct ErrorMessage {
        static let kGenricErrorTitle    = "Try again!"
        static let kGenericErrorMessage = "Something went wrong. Please try again."
        static let kGenericErrorCode    = "GEC0001"
    }
    struct ButtonTitle {
        static let koKTitle    = "ok"
        
    }

    typealias CompletionBlock        = (_ result: AnyObject?   , _ error: SCError?) -> Void
}

