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
            pubdate: Book.toPubYear(from: response.pubdate),
            publisher: response.publisher
        )
    }
    
    static private func toPubYear(from dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let date = formatter.date(from: dateString)
        formatter.dateFormat = "yyyy년"
        
        return formatter.string(from: date ?? Date())
    }
    
}

extension Book: Equatable {
    static func ==(lhs: Book, rhs: Book) -> Bool {
        return lhs.title.lowercased() == rhs.title.lowercased()
    }
}

extension Book: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine("\(title)")
    }
}

