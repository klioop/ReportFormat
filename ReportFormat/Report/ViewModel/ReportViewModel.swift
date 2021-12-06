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

enum ReportSceneType: Int {
    case new
    case editing
}

protocol ReportViewModelProtocol {
    
    typealias Input = (
        didTapCreateButton: Driver<Void>,
        ()
    )
    typealias Output = (
        title: Driver<String>,
        sections: Driver<[ReportItemSection]>,
        reportSceneType: Driver<ReportSceneType>
    )
    typealias ViewBuilder = (ReportViewModelProtocol.Input) -> ReportViewModelProtocol
    typealias Dependencies = (report: Report, realmService: RealmServiceProtocol, sceneType: ReportSceneType)
    
    var input: ReportViewModelProtocol.Input { get }
    var output: ReportViewModelProtocol.Output { get }
    
}

struct ReportViewModel: ReportViewModelProtocol {
    
    typealias RoutingAction = (voidRelay: PublishRelay<Void>, ())
    typealias Routing = (didTapCreateButton: Driver<Void>, ())
    
    private let routingAction: RoutingAction = (PublishRelay(), ())
    lazy var routing: Routing = (
        routingAction.voidRelay.asDriver(onErrorDriveWith: .empty()),
        ()
    )
                                 
    var input: ReportViewModelProtocol.Input
    var output: ReportViewModelProtocol.Output
    
    private var bag = DisposeBag()
    
    init(
        input: ReportViewModelProtocol.Input,
        dependencies: ReportViewModelProtocol.Dependencies
    ) {
        self.input = input
        self.output = ReportViewModel.output(dependencies)
        
        self.process(input: input, dependencies: dependencies)
    }
}

// MARK: - helpers

private extension ReportViewModel {
    
    func process(
        input: ReportViewModelProtocol.Input,
        dependencies: ReportViewModelProtocol.Dependencies
    ) {
        input.didTapCreateButton
            .asObservable()
            .map { [dependencies] (tap) -> Void in
                print("눌림")
                try self.addReportToRealmAndRouting(dependencies)
                routingAction.voidRelay.accept(tap)
                return tap
            }
            .asDriver(onErrorDriveWith: .empty())
            .drive()
            .disposed(by: bag)
    }
    
    func addReportToRealmAndRouting(_ dependencies: ReportViewModelProtocol.Dependencies) throws {
        try dependencies.realmService.addReport(dependencies.report)
        routingAction.voidRelay.accept(())
    }
    
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
        let sceneType = Driver.just(dependencies.sceneType)
        
        return (title, sections, sceneType)
    }
}
