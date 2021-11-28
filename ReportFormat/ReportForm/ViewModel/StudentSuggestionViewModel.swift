//
//  StudentSuggestionViewModel.swift
//  ReportFormat
//
//  Created by klioop on 2021/11/28.
//

import Foundation
import RxCocoa

struct StudentSuggestionViewModel: SuggestionViewModelProtocol {
    let name: String
    let select: PublishRelay<Void>
    
    init(_ studentObject: StudentObject, select: PublishRelay<Void>) {
        self.name = studentObject.name
        self.select = select
    }
    
    init(_ studentObject: StudentObject) {
        self.name = studentObject.name
        self.select = PublishRelay<Void>()
    }
   
}

extension StudentSuggestionViewModel: Equatable {
    static func ==(lhs: StudentSuggestionViewModel, rhs: StudentSuggestionViewModel) -> Bool {
        true
    }
}
