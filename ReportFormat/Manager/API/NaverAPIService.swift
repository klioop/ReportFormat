//
//  NaverAPIService.swift
//  ReportFormat
//
//  Created by klioop on 2021/11/26.
//

import Foundation
import Alamofire

class NaverAPIService: HttpService {
    
    func request(urlRequest: URLRequestConvertible) -> DataRequest {
        return AF.request(urlRequest).validate()
    }
    
    func request(url: URLConvertible, method: HTTPMethod, headers: HTTPHeaders, parameters: Parameters?) -> DataRequest {
        return AF.request(url, method: method, parameters: parameters, headers: headers)
            .validate(statusCode: 200..<400)
            
    }
    
}
