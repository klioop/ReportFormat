//
//  ReportViewModel.swift
//  ReportFormat
//
//  Created by klioop on 2021/12/02.
//

import Foundation
import RxCocoa
import RxDataSources

typealias ReportItemSection = SectionModel<String, ReportCellModelCase>

protocol ReportViewModelProtocol {
    
    typealias Input = (
        didTapCreateButton: Driver<Void>,
        didTapBackButton: Driver<Void>
    )
    typealias Output = (
        title: Driver<String>,
        sections: Driver<[ReportItemSection]>
    )
    typealias ViewBuilder = (ReportViewModelProtocol.Input) -> ReportViewModelProtocol
    typealias Dependencies = (report: Report, ())
    
    var input: ReportViewModelProtocol.Input { get }
    var output: ReportViewModelProtocol.Output { get }
    
}

struct ReportViewModel: ReportViewModelProtocol {
    
    var input: ReportViewModelProtocol.Input
    var output: ReportViewModelProtocol.Output
    
    init(
        input: ReportViewModelProtocol.Input,
        dependencies: ReportViewModelProtocol.Dependencies
    ) {
        self.input = input
        self.output = ReportViewModel.output(dependencies)
    }
}

extension ReportViewModel {
    
    static func output(_ dependencies: ReportViewModelProtocol.Dependencies) -> ReportViewModelProtocol.Output {
        let title = Driver.just(dependencies.report.reportDate + " 수업 리포트")
        let sections = Driver.just(dependencies.report)
            .map { report in
                ReportCellViewModel.init(with: report)
            }
            .map { viewModel in
                [
                    ReportItemSection(model: Constants.ModelName.data, items: [.data(viewModel)]),
                    ReportItemSection(model: Constants.ModelName.comment, items: [.comment(viewModel)])
                ]
            }
        return (title, sections)
    }
}
