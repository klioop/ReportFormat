//
//  BookResponse.swift
//  ReportFormat
//
//  Created by klioop on 2021/11/26.
//

import Foundation

struct BookResponse: Codable {
    let items: [Item]
    
    struct Item: Codable {
        let title: String
        let image: String
        let pubdate: String
        let publisher: String
    }
    
    
}
