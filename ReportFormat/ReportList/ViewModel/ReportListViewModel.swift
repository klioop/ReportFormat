//
//  ReportListViewModel.swift
//  ReportFormat
//
//  Created by klioop on 2021/12/05.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import RxRealm

typealias ReportListSection = SectionModel<String, ReportListCellViewModelType>

enum ReportListCellViewModelType {
    case empty
    case list(ReportListCellViewModel)
}

protocol ReportListViewModelProtocol {
    typealias Input = (
        didTapNewReport: Driver<Void>,
        reportSelected: Driver<Report>,
        indexToDeleteReport: Driver<Int>
    )
    typealias Output = (
        sections: Driver<[ReportListSection]>,
        title: Driver<String>
    )
    typealias Dependencies = (
        realm: RealmServiceProtocol,
        ()
    )
    typealias ViewModelBuilder = (ReportListViewModelProtocol.Input) -> ReportListViewModelProtocol
    
    var input: ReportListViewModelProtocol.Input { get }
    var output: ReportListViewModelProtocol.Output { get }
}

struct ReportListViewModel: ReportListViewModelProtocol {
    typealias RoutingAction = (
        reportRelay: PublishRelay<Report>,
        voidRelay: PublishRelay<Void>
    )
    typealias Routing = (
        report: Driver<Report>,
        tap: Driver<Void>
    )
    private let routingAction: RoutingAction = (PublishRelay(), PublishRelay())
    lazy var routing: Routing = (
        routingAction.reportRelay.asDriver(onErrorDriveWith: .empty()),
        routingAction.voidRelay.asDriver(onErrorDriveWith: .empty())
    )
    private var bag = DisposeBag()
    
    var input: ReportListViewModelProtocol.Input
    var output: ReportListViewModelProtocol.Output
    let dependencies: ReportListViewModelProtocol.Dependencies

    
    init(
        input: ReportListViewModelProtocol.Input,
        dependencies: ReportListViewModelProtocol.Dependencies
    ) {
        self.input = input
        self.output = ReportListViewModel.output(dependencies: dependencies)
        self.dependencies = dependencies
        
        self.process(input: input)
    }
    
}

private extension ReportListViewModel {
    
    private func process(
        input: ReportListViewModelProtocol.Input
    ) {
        input.didTapNewReport
            .map {
                routingAction.voidRelay.accept(())
            }
            .drive()
            .disposed(by: bag)
        
        input.reportSelected
            .map {
                routingAction.reportRelay.accept($0)
            }
            .drive()
            .disposed(by: bag)
        
        input.indexToDeleteReport
            .asObservable()
            .map {
                try dependencies.realm.removeReport($0)
            }
            .asDriver(onErrorDriveWith: .empty())
            .drive()
            .disposed(by: bag)
    }
    
    static func output(dependencies: ReportListViewModelProtocol.Dependencies) -> ReportListViewModelProtocol.Output{
        let title = Driver.just("리포트")
        let reports = dependencies.realm.getReports()
        let sections = Observable.arrayWithChangeset(from: reports)
            .map { (array, _) -> [Report] in
                return Report.toReports(from: array)
            }
            .map { reports -> [ReportListSection] in
                if reports.isEmpty {
                    return [
                        ReportListSection(model: "empty", items: [.empty])
                    ]
                } else {
                    return [
                        ReportListSection(model: "reports", items: reports.map(ReportListCellViewModel.init).map(ReportListCellViewModelType.list))
                    ]
                }
            }
            .asDriver(onErrorDriveWith: .empty())
            
        
        return (sections, title)
    }
}
