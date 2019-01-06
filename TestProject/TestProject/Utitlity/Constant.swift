//
//  Constant.swift
//  ShareChat
//
//  Created by Yogesh on 7/28/18.
//  Copyright © 2018 test. All rights reserved.
//

import Foundation

struct Constant {
    struct Api {
        static let kEndPoint  = "http://10.2.41.69:3134/"
        static let kGetRequest = "GET"
    }

    
    struct CellIdentifier {
        static let kArticleCell  = "ArticleCell"
    }

    struct JsonKeys {
        static let kError        = "error"
        static let kdata         = "data"
        static let kAuthorName   = "authorName"
        static let kArticles     = "articles"
        static let kStatus       = "status"
        static let ktotalResults       = "totalResults"
        
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

