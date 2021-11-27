//
//  HttpService.swift
//  ReportFormat
//
//  Created by klioop on 2021/11/26.
//

import Alamofire
import Foundation

protocol HttpService {
    func request(urlRequest: URLRequestConvertible) -> DataRequest
}
