//
//  CustomErrors.swift
//  ReportFormat
//
//  Created by klioop on 2021/11/26.
//

import Foundation

enum APIError: Error {
    case invalidUrl
    case failedToParseJSON
    
    var errorMessage: String {
        switch self {
        case .invalidUrl:
            return "Invalid Url"
        case .failedToParseJSON:
            return "Failed to parse JSON from network"
        }
    }
}

enum RealmError: Error {
    case failedToAddObject
    
    var errorMessage: String {
        switch self {
        case .failedToAddObject:
            return "Failed to add a new object"
        }
    }
}
