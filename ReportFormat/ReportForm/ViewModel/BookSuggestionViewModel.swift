//
//  BookSuggestionViewModel.swift
//  ReportFormat
//
//  Created by klioop on 2021/11/26.
//

import Foundation
import RxSwift
import RxRelay

struct BookSuggestionViewModel: SuggestionViewModelProtocol {
    
    var text = BehaviorRelay<String>(value: "")
    var select: PublishRelay<Void>
    
    init(_ book: Book, select: PublishRelay<Void>) {
        self.select = select
    }
    
}
