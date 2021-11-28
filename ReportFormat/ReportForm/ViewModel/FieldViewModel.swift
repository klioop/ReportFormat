//
//  FieldViewModel.swift
//  ReportFormat
//
//  Created by klioop on 2021/11/28.
//

import Foundation
import RxCocoa

struct FieldViewModel {
    let title: String = ""
    
    let text = BehaviorRelay<String>(value: "")
    let focus = PublishRelay<Void>()
}

extension FieldViewModel: Equatable {
    static func ==(lhs: FieldViewModel, rhs: FieldViewModel) -> Bool {
        return true
    }
}
