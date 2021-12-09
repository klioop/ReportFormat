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
    var report: Report
    let reportSceneType: ReportSceneType
    let reportEdittedFromForm = PublishRelay<Report>()
    
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
    
        vc.viewModelBuilder = { [report, realmService, bag, reportSceneType, reportEdittedFromForm] in
            
            var viewModel = ReportViewModel(
                input: $0,
                dependencies: (report, realmService, reportSceneType, reportEdittedFromForm)
            )
            
            viewModel.routing.didTapCreateButton
                .map { [weak self] in
                    self?.dismissModal()
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
        switch reportSceneType {
        case .new:
            router.pushOnModal(vc, isAnimated: true, onNavigationBack: isComplted)
        case .editing:
            router.push(vc, isAnimated: true, onNavigationBack: isComplted)
        }
        
        
    }
}

private extension ReportCoordinator {
    func dismissModal() {
        router.dismiss(true)
    }
    
    func popToRoot() {
        router.popToRoot(true)
    }
    
    func showFormEditting(with report: Report) {
        let coordinator = ReportFormCoordinator(router: router, sceneType: .editing, report: report, reportEditted: reportEdittedFromForm)
        
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
