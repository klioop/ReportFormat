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
import RxRealm

typealias ReportItemSection = SectionModel<String, ReportCellModelCase>

protocol ReportViewModelProtocol {
    
    typealias Input = (
        didTapCreateButton: Driver<Void>,
        didTapEditButton: Driver<Void>
    )
    typealias Output = (
        title: Driver<String>,
        sections: Driver<[ReportItemSection]>,
        reportSceneType: Driver<ReportSceneType>
    )
    typealias ViewBuilder = (ReportViewModelProtocol.Input) -> ReportViewModelProtocol
    typealias Dependencies = (
        report: Report,
        realmService: RealmServiceProtocol,
        sceneType: ReportSceneType,
        reportRelayFromForm: PublishRelay<Report>
    )
    
    var input: ReportViewModelProtocol.Input { get }
    var output: ReportViewModelProtocol.Output { get }
    
}

struct ReportViewModel: ReportViewModelProtocol {
    
    typealias RoutingAction = (voidRelay: PublishRelay<Void>, reportRelay: PublishRelay<Report>)
    typealias Routing = (didTapCreateButton: Driver<Void>, editReport: Driver<Report>)
    
    private let routingAction: RoutingAction = (PublishRelay(), PublishRelay())
    lazy var routing: Routing = (
        routingAction.voidRelay.asDriver(onErrorDriveWith: .empty()),
        routingAction.reportRelay.asDriver(onErrorDriveWith: .empty())
    )
                                 
    var input: ReportViewModelProtocol.Input
    var output: ReportViewModelProtocol.Output
    
    var reportFromForm = BehaviorRelay<Report>(value: Report.emptyReport())
    
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
                try self.addReportToRealmAndRouting(dependencies)
                routingAction.voidRelay.accept(tap)
                return tap
            }
            .asDriver(onErrorDriveWith: .empty())
            .drive()
            .disposed(by: bag)
        
        input.didTapEditButton
                .map { [dependencies, routingAction] (tap) in
                    let report = reportFromForm.value.reportDate.isEmpty ? dependencies.report : reportFromForm.value
                    routingAction.reportRelay.accept(report)
                }
                .drive()
                .disposed(by: bag)
        
        dependencies.reportRelayFromForm
            .bind(to: reportFromForm)
            .disposed(by: bag)
        
    }
    
    func addReportToRealmAndRouting(_ dependencies: ReportViewModelProtocol.Dependencies) throws {
        try dependencies.realmService.addReport(dependencies.report)
        routingAction.voidRelay.accept(())
    }
    
    static func output(_ dependencies: ReportViewModelProtocol.Dependencies) -> ReportViewModelProtocol.Output {
        let title = Driver.just(dependencies.report.reportDate)
        let reports = dependencies.realmService.getReports()
        let sections = Observable.arrayWithChangeset(from: reports)
            .map { (array, _) -> Report in
                let report = ReportViewModel.reportUponSceneType(with: array, dependencies)
                return report
            }
            .asDriver(onErrorDriveWith: .empty())
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
    
    static func reportUponSceneType(with array: [ReportObject], _ dependencies: ReportViewModelProtocol.Dependencies) -> Report {
        switch dependencies.sceneType {
        case .editing:
            guard let report = array.filter({ $0._id == (dependencies.report.objectId!) }).first else { return Report.emptyReport() }
            return Report.toReport(from: report)
        case .new:
            return dependencies.report
        }
    }
}
