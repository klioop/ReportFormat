//
//  Book.swift
//  ReportFormat
//
//  Created by klioop on 2021/11/27.
//

import Foundation

struct Book {
    let title: String
    let imageUrl: String
    let pubdate: String
    let publisher: String
    
}

extension Book {
    static func toBook(from response: BookResponse.Item) -> Book {
        return Book(
            title: response.title,
            imageUrl: response.image,
            pubdate: response.pubdate,
            publisher: response.publisher
        )
    }
}
