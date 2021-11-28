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
    
    static var instanceId: Int = 0
    
    let name: String
    let select: PublishRelay<Void>
    
    init(_ studentObject: StudentObject, select: PublishRelay<Void>) {
        self.name = studentObject.name
        self.select = select
        StudentSuggestionViewModel.instanceId += 1
    }
    
    init(_ studentObject: StudentObject) {
        self.name = studentObject.name
        self.select = PublishRelay<Void>()
    }
   
}

extension StudentSuggestionViewModel: IdentifiableType {
    var identity: String {
        "\(self.name)-\(StudentSuggestionViewModel.instanceId)"
    }
}

extension StudentSuggestionViewModel: Equatable {
    static func ==(lhs: StudentSuggestionViewModel, rhs: StudentSuggestionViewModel) -> Bool {
        true
    }
}
