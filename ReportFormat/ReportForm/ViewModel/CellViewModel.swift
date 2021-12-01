//
//  CellViewModel.swift
//  ReportFormat
//
//  Created by klioop on 2021/12/01.
//

import Foundation
import RxDataSources

enum CellViewModel: IdentifiableType {
    case fields(FieldViewModel)
    case datePicker(DatePickerViewModel)
    case suggestion(SuggestionViewModelProtocol)
    case comment(CommentViewModel)
    
    var identity: String {
        switch self {
        case let .fields(vm): return vm.title
        case let .datePicker(vm): return vm.identity
        case let .suggestion(vm): return vm.identity
        case let .comment(vm): return vm.identity
        }
    }
}

extension CellViewModel: Equatable {
    static func ==(lhs: CellViewModel, rhs: CellViewModel) -> Bool {
        lhs.identity == rhs.identity
    }
}
