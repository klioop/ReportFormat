//
//  CommentViewModel.swift
//  ReportFormat
//
//  Created by klioop on 2021/11/28.
//

import Foundation
import RxCocoa

struct CommentViewModel {
    let tapButton: PublishRelay<Void>
    let commentText = BehaviorRelay<String>(value: "")
    
    init(tapButton: PublishRelay<Void>) {
        self.tapButton = tapButton
    }
    
}

extension CommentViewModel {
    init() {
        self.tapButton = PublishRelay<Void>()
    }
}

extension CommentViewModel: Equatable {
    static func ==(lhs: CommentViewModel, rhs: CommentViewModel) -> Bool {
        return true
    }
}
