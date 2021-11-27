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
        var headers = HTTPHeaders()
        headers.add(.init(name: "X-Naver-Client-Id", value: "b9k_fmXD5I0489ym9jxL"))
        headers.add(.init(name: "X-Naver-Client-Secret", value: "_whh_4dX6Y"))
        return headers
    }
    
    func request(with service: NaverAPIService, parameters: [String: String]) throws -> DataRequest {
        var url = try baseURL.asURL()
        url = url.appendingPathComponent(path)
        return service.request(url: url, method: method, headers: headers, parameters: parameters)
    }
    
    
}


