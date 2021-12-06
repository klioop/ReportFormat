//
//  ReportCoordinator.swift
//  ReportFormat
//
//  Created by klioop on 2021/12/02.
//

import Foundation
import RxSwift
import RxCocoa

class ReportCoordinator: BaseCoordinator {
    
    let router: RouterProtocol
    let report: Report
    let reportSceneType: ReportSceneType
    
    private var bag = DisposeBag()
    
    init(
        router: RouterProtocol,
        report: Report,
        reportSceneType: ReportSceneType
    ) {
        self.router = router
        self.report = report
        self.reportSceneType = reportSceneType
    }
    
    override func start() {
        let vc = ReportViewController.instantiate()
        let realmService = RealmService.shared
    
        vc.viewModelBuilder = { [report, realmService, bag, reportSceneType] in
            var viewModel = ReportViewModel(
                input: $0,
                dependencies: (report, realmService, reportSceneType)
            )
            
            viewModel.routing.didTapCreateButton
                .map { [weak self] in
                    self?.popToRoot()
                }
                .drive()
                .disposed(by: bag)
            
            viewModel.routing.editReport
                .map { [weak self] (report) in
                    self?.showFormEditting(with: report)
                }
                .drive()
                .disposed(by: bag)
            
            return viewModel
        }
        router.push(vc, isAnimated: true, onNavigationBack: isComplted)
    }
}

private extension ReportCoordinator {
    func popToRoot() {
        router.popToRoot(true)
    }
    
    func showFormEditting(with report: Report) {
        let coordinator = ReportFormCoordinator(router: router, sceneType: .editing, report: report)
        coordinator.isComplted = { [weak self, weak coordinator] in
            guard
                let self = self,
                let coordinator = coordinator
            else { return }
            self.remove(coordinator)
        }
        coordinator.start()
    }

}
