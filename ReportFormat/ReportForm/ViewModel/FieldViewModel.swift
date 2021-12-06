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
    
    var text = BehaviorRelay<String>(value: "")
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
    
    static func date(_ report: Report?) -> FieldViewModel {
        var model = FieldViewModel(title: Constants.FieldTitle.date)
        model.text = BehaviorRelay<String>(value: report?.reportDate ?? "")
        
        return model
    }
    
    static func student(_ report: Report?) -> FieldViewModel {
        var model = FieldViewModel(title: Constants.FieldTitle.student)
        model.text = BehaviorRelay<String>(value: report?.studentName ?? "")
        
        return model
    }
    
    static func subject(_ report: Report?) -> FieldViewModel {
        var model = FieldViewModel(title: Constants.FieldTitle.subject)
        model.text = BehaviorRelay<String>(value: report?.subject ?? "")
        
        return model
    }
    
    static func book(_ report: Report?) -> FieldViewModel {
        var model = FieldViewModel(title: Constants.FieldTitle.book)
        model.text = BehaviorRelay<String>(value: report?.bookTitle ?? "")
        
        return model
    }
    
    static func range(_ report: Report?) -> FieldViewModel {
        var model = FieldViewModel(title: Constants.FieldTitle.range)
        model.text = BehaviorRelay<String>(value: report?.range ?? "")
        
        return model
    }
    
    static func comment() -> FieldViewModel {
        FieldViewModel(title: Constants.FieldTitle.comment)
    }
}
