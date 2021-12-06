//
//  CommentViewModel.swift
//  ReportFormat
//
//  Created by klioop on 2021/11/28.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

struct CommentViewModel {
    let tapButton: PublishRelay<Void>
    var commentText = BehaviorRelay<String>(value: "")
    var commentTextFromEditting = BehaviorRelay<String>(value: "")
    private var bag = DisposeBag()
    
    init(tapButton: PublishRelay<Void>) {
        self.tapButton = tapButton
    }
    
}

extension CommentViewModel: IdentifiableType {
    var identity: String {
        "CommentViewModel"
    }
}

extension CommentViewModel {
    init() {
        self.tapButton = PublishRelay<Void>()
    }
    
    func bind(to field: FieldViewModel) {
        commentTextFromEditting
            .bind(to: commentText)
            .disposed(by: bag)
        
        commentText
            .filter { !($0 == Constants.commentTextViewPlaceHolder) }
            .asDriver(onErrorDriveWith: .empty())
            .drive(field.text)
            .disposed(by: bag)
    }
}

extension CommentViewModel: Equatable {
    static func ==(lhs: CommentViewModel, rhs: CommentViewModel) -> Bool {
        return true
    }
}
