//
//  NaverAPIService.swift
//  ReportFormat
//
//  Created by klioop on 2021/11/26.
//

import Foundation
import Alamofire

class NaverAPIService: HttpService {
    
    var sessionManager: Session = .default
    
    func request(urlRequest: URLRequestConvertible) -> DataRequest {
        sessionManager.request(urlRequest).validate(statusCode: 200..<400)
    }
    
}
