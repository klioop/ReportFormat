//
//  ButtonViewModel.swift
//  ReportFormat
//
//  Created by klioop on 2021/11/28.
//

import Foundation
import RxCocoa

struct ButtonViewModel {
    let isEnabled = BehaviorRelay<Bool>(value: false)
    let isHidden = BehaviorRelay<Bool>(value: false)
}

extension ButtonViewModel: Equatable {
    static func ==(lhs: ButtonViewModel, rhs: ButtonViewModel) -> Bool {
        return true
    }
}
