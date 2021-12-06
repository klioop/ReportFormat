//
//  ButtonViewModel.swift
//  ReportFormat
//
//  Created by klioop on 2021/11/28.
//

import Foundation
import RxCocoa

struct ButtonViewModel {
    let sceneType: ReportFormSceneType
    let buttonTitle: Driver<String>
    
    let isEnabled = BehaviorRelay<Bool>(value: false)
    let isHidden = BehaviorRelay<Bool>(value: false)
    
    init(sceneType: ReportFormSceneType) {
        self.sceneType = sceneType
        
        switch sceneType {
        case .editing:
            self.buttonTitle = Driver.just(Constants.ReportFormButtonTitle.edit)
        case .new:
            self.buttonTitle = Driver.just(Constants.ReportFormButtonTitle.new)
        }
    }
}

extension ButtonViewModel: Equatable {
    static func ==(lhs: ButtonViewModel, rhs: ButtonViewModel) -> Bool {
        return true
    }
}

extension ButtonViewModel {
    
}
