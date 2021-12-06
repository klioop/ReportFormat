//
//  ReportFormCoordinator.swift
//  ReportFormat
//
//  Created by klioop on 2021/11/29.
//

import UIKit
import RxSwift
import RxCocoa


class ReportFormCoordinator: BaseCoordinator {
    
    let router: RouterProtocol
    let report: Report?
    let sceneType: ReportFormSceneType
    
    private let bag = DisposeBag()
    private let didDismss = PublishRelay<Void>()
    
    init(router: RouterProtocol, sceneType: ReportFormSceneType, report: Report? = nil) {
        self.router = router
        self.report = report
        self.sceneType = sceneType
    }
    
    override func start() {
        let vc = ReportFormViewController.instantiate()
        let apiService = BookAPIManager.shared
        let realmService = RealmService.shared
        
        vc.viewModelBuilder = { [sceneType, bag, report] in
            var viewModel = ReportFormViewModel(
                date: .date(report),
                student: .student(report),
                subject: .subject(report),
                book: .book(report),
                range: .range(report),
                comment: .comment(),
                buttonViewModel: ButtonViewModel(),
                realmService: realmService,
                bookService: apiService,
                sceneType: sceneType,
                report: report
            )
            
            viewModel.routing.report
                .map { [weak self] in
                    self?.showReport($0)
                }
                .drive()
                .disposed(by: bag)
            
            return viewModel
        }
        router.push(vc, isAnimated: true, onNavigationBack: isComplted)
    }
}

private extension ReportFormCoordinator {
    
    func showReport(_ report: Report) {
        let reportCoordinator = ReportCoordinator(router: self.router, report: report, reportSceneType: .new)
        reportCoordinator.isComplted = { [weak self, weak reportCoordinator] in
            guard
                let self = self,
                let coordinator = reportCoordinator
            else { return }
            self.remove(coordinator)
        }
        reportCoordinator.start()
    }
}

