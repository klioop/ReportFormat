//
//  ReportViewModel.swift
//  ReportFormat
//
//  Created by klioop on 2021/12/02.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

typealias ReportItemSection = SectionModel<String, ReportCellModelCase>

protocol ReportViewModelProtocol {
    
    typealias Input = (
        didTapCreateButton: Driver<Void>,
        ()
    )
    typealias Output = (
        title: Driver<String>,
        sections: Driver<[ReportItemSection]>
    )
    typealias ViewBuilder = (ReportViewModelProtocol.Input) -> ReportViewModelProtocol
    typealias Dependencies = (report: Report, realmService: RealmServiceProtocol)
    
    var input: ReportViewModelProtocol.Input { get }
    var output: ReportViewModelProtocol.Output { get }
    
}

struct ReportViewModel: ReportViewModelProtocol {
    
    typealias RoutingAction = (reportRelay: PublishRelay<ReportObject>, ())
    typealias Routing = (report: Driver<ReportObject>, ())
    
    private let routingAction: RoutingAction = (PublishRelay(), ())
    lazy var routing: Routing = (
        routingAction.reportRelay.asDriver(onErrorDriveWith: .empty()),
        ()
    )
                                 
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

private extension ReportViewModel {
    
    func process(
        input: ReportViewModelProtocol.Input,
        dependencies: ReportViewModelProtocol.Dependencies
    ) {
        input.didTapCreateButton
            .map {
                
            }
    }
    
    static func output(_ dependencies: ReportViewModelProtocol.Dependencies) -> ReportViewModelProtocol.Output {
        let title = Driver.just(dependencies.report.reportDate + " 수업 리포트")
        let sections = Driver.just(dependencies.report)
            .map { report in
                print(report)
                return ReportCellViewModel.init(with: report)
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
