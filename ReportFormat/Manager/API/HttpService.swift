//
//  HttpService.swift
//  ReportFormat
//
//  Created by klioop on 2021/11/26.
//

import Alamofire

protocol HttpService {
    var sessionManager: Session { get set }
    
    func request(urlRequest: URLRequestConvertible) -> DataRequest
}
