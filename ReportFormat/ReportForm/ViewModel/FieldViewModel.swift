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
        FieldViewModel(title: "날짜")
    }
    
    static func student() -> FieldViewModel {
        FieldViewModel(title: "학생 이름")
    }
    
    static func subject() -> FieldViewModel {
        FieldViewModel(title: "과목")
    }
    
    static func book() -> FieldViewModel {
        FieldViewModel(title: "책")
    }
    
    static func range() -> FieldViewModel {
        FieldViewModel(title: "범위")
    }
    
    static func comment() -> FieldViewModel {
        FieldViewModel(title: "코맨트")
    }
}
