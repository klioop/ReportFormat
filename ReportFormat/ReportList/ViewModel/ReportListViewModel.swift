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

typealias ReportListSection = SectionModel<String, ReportListCellViewModelType>

enum ReportListCellViewModelType {
    case empty
    case list(ReportListCellViewModel)
}

protocol ReportListViewModelProtocol {
    typealias Input = (
        didTapNewReport: Driver<Void>,
        ()
    )
    typealias Output = (
        sections: Driver<[ReportListSection]>,
        ()
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
    
    var input: ReportListViewModelProtocol.Input
    var output: ReportListViewModelProtocol.Output
    
    init(
        input: ReportListViewModelProtocol.Input,
        dependencies: ReportListViewModelProtocol.Dependencies
    ) {
        self.input = input
        self.output = ReportListViewModel.output(dependencies: dependencies)
    }
    
}

private extension ReportListViewModel {
    
    private func process() {
        
    }
    
    static func output(dependencies: ReportListViewModelProtocol.Dependencies) -> ReportListViewModelProtocol.Output{
        
        let sections = dependencies.realm.getAllReports()
            .asObservable()
            .map {
                Report.toReports(from: $0)
            }
            .map { (reports) -> [ReportListSection]  in
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
            
        
        return (sections, ())
    }
}
