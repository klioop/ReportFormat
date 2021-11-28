//
//  SubjectSuggestionViewModel.swift
//  ReportFormat
//
//  Created by klioop on 2021/11/28.
//

import Foundation
import RxCocoa

struct SubjectSuggestionViewModel: SuggestionViewModelProtocol {
    let name: String
    let select: PublishRelay<Void>
    
    init(_ subjectObject: SubjectObject, select: PublishRelay<Void>) {
        self.name = subjectObject.name
        self.select = select
    }

}

extension SubjectSuggestionViewModel {
    init(_ subjectObject: SubjectObject) {
        self.name = subjectObject.name
        self.select = PublishRelay<Void>()
    }
}

extension SubjectSuggestionViewModel: Equatable {
    static func ==(lhs: SubjectSuggestionViewModel, rhs: SubjectSuggestionViewModel) -> Bool {
        return true
    }
}
