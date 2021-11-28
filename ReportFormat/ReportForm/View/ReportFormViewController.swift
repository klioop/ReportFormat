//
//  ReportFormViewController.swift
//  ReportFormat
//
//  Created by klioop on 2021/11/28.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

enum CellViewModel: IdentifiableType {
    case fields(FieldViewModel)
    case datePicker(DatePickerViewModel)
    case suggestion(SuggestionViewModelProtocol)
    case comment(CommentViewModel)
    
    var identity: String {
        switch self {
        case let .fields(vm): return vm.identity
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

class ReportFormViewController: UIViewController, StoryBoarded {
    
    typealias ReportFormSection = AnimatableSectionModel<String, CellViewModel>
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

