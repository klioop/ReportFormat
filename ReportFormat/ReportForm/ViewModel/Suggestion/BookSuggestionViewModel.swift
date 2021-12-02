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
    
    var title: String
    var select: PublishRelay<Void>
    var type: SuggestionType = .book
    let book: Book
    
    init(_ book: Book, select: PublishRelay<Void>) {
        self.select = select
        self.title = "\(book.title)"
        self.book = book
    }
    
}

extension BookSuggestionViewModel: IdentifiableType {
    var identity: String {
        "\(self.title)"
    }
}

extension BookSuggestionViewModel {
    init(_ book: Book) {
        self.title = ""
        self.select = PublishRelay<Void>()
        self.book = book
    }
}
