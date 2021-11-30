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
    init() {
        self.title = ""
        self.imageUrl = ""
        self.pubdate = ""
        self.publisher = ""
    }
}

extension Book {
    static func toBook(from response: BookResponse.Item) -> Book {
        let title = response.title.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
        return Book(
            title: title,
            imageUrl: response.image,
            pubdate: response.pubdate,
            publisher: response.publisher
        )
    }
}

extension Book: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine("\(title)-\(pubdate)")
    }
}

