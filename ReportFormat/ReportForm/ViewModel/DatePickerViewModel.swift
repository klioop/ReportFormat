//
//  DatePickerViewModel.swift
//  ReportFormat
//
//  Created by klioop on 2021/11/28.
//

import Foundation
import RxCocoa
import RxDataSources

struct DatePickerViewModel {
    let dateString: PublishRelay<String> = PublishRelay()
    let date = BehaviorRelay<Date>(value: Date())
    let tapButton: PublishRelay<Void>
    
    init(tapButton: PublishRelay<Void>) {
        self.tapButton = tapButton
    }
}

extension DatePickerViewModel: IdentifiableType {
    
    var identity: String {
        "DatePickerViewModel"
    }
}

extension DatePickerViewModel {
    
    init() {
        self.tapButton = PublishRelay<Void>()
    }
}

extension DatePickerViewModel: Equatable {
    static func == (lhs: DatePickerViewModel, rhs: DatePickerViewModel) -> Bool {
        true
    }
}
