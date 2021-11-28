//
//  BookSuggestionViewModel.swift
//  ReportFormat
//
//  Created by klioop on 2021/11/26.
//

import Foundation
import RxSwift
import RxRelay
import RxDataSources

struct BookSuggestionViewModel: SuggestionViewModelProtocol {
    
    var text: String
    var select: PublishRelay<Void>
    
    init(_ book: Book, select: PublishRelay<Void>) {
        self.select = select
        self.text = "제목: \(book.title) | 출판일: \(book.pubdate)"
    }
    
}

extension BookSuggestionViewModel: IdentifiableType {
    var identity: String {
        "\(self.text)"
    }
}

extension BookSuggestionViewModel {
    init(_ book: Book) {
        self.text = ""
        self.select = PublishRelay<Void>()
    }
}
