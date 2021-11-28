//
//  ReportFormState.swift
//  ReportFormat
//
//  Created by klioop on 2021/11/28.
//

import Foundation

enum State: Equatable {
    case initial(fields: [FieldViewModel], button: ButtonViewModel)
    case focusDate(datePickerVM: DatePickerViewModel)
    case focus(field: FieldViewModel, suggestionViewModels: [SuggestionViewModelProtocol])
    case focusComment(CommentViewModel)
    
    static func == (lhs: State, rhs: State) -> Bool{
        return true
    }
}
