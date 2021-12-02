//
//  FieldViewModel.swift
//  ReportFormat
//
//  Created by klioop on 2021/11/28.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

struct FieldViewModel {
    let title: String
    
    let text = BehaviorRelay<String>(value: "")
    let focus = PublishRelay<Void>()
    var textForSearch = BehaviorRelay<String>(value: "")
    var isSearch = BehaviorRelay<Bool>(value: false)
    let textForEmptyCheck = BehaviorRelay<String>(value: "")
    let bookImageUrl = BehaviorRelay<String>(value: "")
}

extension FieldViewModel: IdentifiableType {
    var identity: String { title }
}

extension FieldViewModel: Equatable {
    static func ==(lhs: FieldViewModel, rhs: FieldViewModel) -> Bool {
        return lhs.text.value == rhs.text.value && lhs.title == rhs.title
    }
}

extension FieldViewModel {
    
    init() {
        self.title = ""
    }
    
    static func date() -> FieldViewModel {
        FieldViewModel(title: Constants.FieldTitle.date)
    }
    
    static func student() -> FieldViewModel {
        FieldViewModel(title: Constants.FieldTitle.student)
    }
    
    static func subject() -> FieldViewModel {
        FieldViewModel(title: Constants.FieldTitle.subject)
    }
    
    static func book() -> FieldViewModel {
        FieldViewModel(title: Constants.FieldTitle.book)
    }
    
    static func range() -> FieldViewModel {
        FieldViewModel(title: Constants.FieldTitle.range)
    }
    
    static func comment() -> FieldViewModel {
        FieldViewModel(title: Constants.FieldTitle.comment)
    }
}
