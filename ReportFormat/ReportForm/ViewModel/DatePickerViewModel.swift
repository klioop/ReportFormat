//
//  DatePickerViewModel.swift
//  ReportFormat
//
//  Created by klioop on 2021/11/28.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

struct DatePickerViewModel {
    let dateString: PublishRelay<String> = PublishRelay()
    let date = PublishRelay<Date>()
    let tapButton: PublishRelay<Void>
    var dateStringFromEditting = BehaviorRelay<String>(value: "")
    
    private let bag = DisposeBag()
    
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
    
    func bind(to field: FieldViewModel) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일"
        
        date
            .map { [formatter] (date) -> String in
                return formatter.string(from: date)
            }
            .bind(to: field.text)
            .disposed(by: bag)
    }
    
    func temp() {
        
    }
}

extension DatePickerViewModel: Equatable {
    static func == (lhs: DatePickerViewModel, rhs: DatePickerViewModel) -> Bool {
        true
    }
}
