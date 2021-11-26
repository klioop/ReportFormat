//
//  NaverBookAPIRouter.swift
//  ReportFormat
//
//  Created by klioop on 2021/11/26.
//

import Foundation
import Alamofire

enum NaverAPIRouter {
    case getBooks
}

extension NaverAPIRouter: HttpRouter {
    
    var baseURL: String {
        "https://openapi.naver.com/v1/search"
    }
    
    var path: String {
        switch self {
        case .getBooks:
            return "book.json"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getBooks:
            return .get
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .getBooks:
            return .init(
                dictionaryLiteral:
                    ("X-Naver-Client-Id", Secret.clientID),
                    ("X-Naver-Client-Secret", Secret.clientSecret)
            )
        }
    }
    
}


