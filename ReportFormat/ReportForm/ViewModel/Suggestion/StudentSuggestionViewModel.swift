//
//  StudentSuggestionViewModel.swift
//  ReportFormat
//
//  Created by klioop on 2021/11/28.
//

import Foundation
import RxCocoa
import RxDataSources

struct StudentSuggestionViewModel: SuggestionViewModelProtocol {
    
    let name: String
    let select: PublishRelay<Void>
    var type: SuggestionType = .student
    
    init(_ studentObject: StudentObject, select: PublishRelay<Void>) {
        self.name = studentObject.name
        self.select = select
    }
    
    init(_ studentObject: StudentObject) {
        self.name = studentObject.name
        self.select = PublishRelay<Void>()
    }
    
    func bindText(field: FieldViewModel) {
        
    }
   
}

extension StudentSuggestionViewModel: IdentifiableType {
    var identity: String {
        "\(self.name)"
    }
}

extension StudentSuggestionViewModel: Equatable {
    static func ==(lhs: StudentSuggestionViewModel, rhs: StudentSuggestionViewModel) -> Bool {
        true
    }
}
