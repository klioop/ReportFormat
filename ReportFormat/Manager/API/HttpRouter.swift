//
//  HttpRouter.swift
//  ReportFormat
//
//  Created by klioop on 2021/11/26.
//

import Foundation
import Alamofire

protocol HttpRouter {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
        
    func request(with service: HttpService) throws -> DataRequest
}

extension HttpRouter {
    var headers: HTTPHeaders? { nil }
    var parameter: Parameters? { nil }
    
    func body() throws -> Data? { return nil }
    
    func asURLRequest() throws -> URLRequest {
        var url = try baseURL.asURL()
        url = url.appendingPathComponent(path)
        var request = try URLRequest(url: url, method: method, headers: headers)
        request.httpBody = try body()
        
        return request
    }
    
    func request(with service: HttpService) throws -> DataRequest {
        try service.request(urlRequest: asURLRequest())
    }
    
}
