//
//  BookSuggestionViewModel.swift
//  ReportFormat
//
//  Created by klioop on 2021/11/26.
//

import Foundation
import RxSwift
import RxRelay

struct BookSuggestionViewModel {
    var text = BehaviorRelay<String>(value: "")
}
