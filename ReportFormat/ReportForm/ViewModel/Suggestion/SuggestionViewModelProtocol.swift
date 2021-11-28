//
//  SuggestionViewModelProtocol.swift
//  ReportFormat
//
//  Created by klioop on 2021/11/27.
//


import RxCocoa

enum SuggestionType {
    case book
    case student
    case subject
}

protocol SuggestionViewModelProtocol {
    var select: PublishRelay<Void> { get }
    var identity: String { get }
    var `type`: SuggestionType { get }
}
