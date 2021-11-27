//
//  SuggestionViewModelProtocol.swift
//  ReportFormat
//
//  Created by klioop on 2021/11/27.
//


import RxCocoa

protocol SuggestionViewModelProtocol {
    var select: PublishRelay<Void> { get }
}
