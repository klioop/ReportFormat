//
//  ReportViewModel.swift
//  ReportFormat
//
//  Created by klioop on 2021/12/02.
//

import Foundation

protocol ReportViewModelProtocol {
    
    typealias Input = ()
    typealias Output = ()
    
    var input: ReportViewModelProtocol.Input { get }
    var output: ReportViewModelProtocol.Output { get }
}

struct ReportViewModel: ReportViewModelProtocol {
    
    var input: ReportViewModelProtocol.Input
    var output: ReportViewModelProtocol.Output
    
    init(input: ReportViewModelProtocol.Input) {
        self.input = input
        self.output = ReportViewModel.output(input)
    }
}

extension ReportViewModelProtocol {
    
    static func output(_ input: ReportViewModelProtocol.Input) -> ReportViewModelProtocol.Output {
        return ()
    }
}
