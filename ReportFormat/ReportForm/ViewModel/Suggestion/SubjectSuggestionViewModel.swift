//
//  SubjectSuggestionViewModel.swift
//  ReportFormat
//
//  Created by klioop on 2021/11/28.
//

import Foundation
import RxCocoa
import RxDataSources
import RxSwift

struct SubjectSuggestionViewModel: SuggestionViewModelProtocol {
    let name: String
    let select: PublishRelay<Void>
    var type: SuggestionType = .subject
    
    private let bag = DisposeBag()
    
    init(_ subjectObject: SubjectObject, select: PublishRelay<Void>) {
        self.name = subjectObject.name
        self.select = select
    }

}

extension SubjectSuggestionViewModel: IdentifiableType {
    var identity: String {
        "\(self.name)"
    }
}

extension SubjectSuggestionViewModel {
    init(_ subjectObject: SubjectObject) {
        self.name = subjectObject.name
        self.select = PublishRelay<Void>()
    }
    
    func bindText(field: FieldViewModel) {
        field.text.accept(name)
    }
}

extension SubjectSuggestionViewModel: Equatable {
    static func ==(lhs: SubjectSuggestionViewModel, rhs: SubjectSuggestionViewModel) -> Bool {
        return true
    }
}
