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
        ()
    )
    typealias Dependencies = (
        realm: RealmServiceProtocol,
        ()
    )
    
    var input: ReportListViewModelProtocol.Input { get }
    var output: ReportListViewModelProtocol.Output { get }
}

struct ReportListViewModel: ReportListViewModelProtocol {
    
    
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
    static func output(dependencies: ReportListViewModelProtocol.Dependencies) -> ReportListViewModelProtocol.Output{
        return ()
    }
}
