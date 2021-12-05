//
//  ReportListCoordinator.swift
//  ReportFormat
//
//  Created by klioop on 2021/12/05.
//

import Foundation
import RxSwift
import RxCocoa

class ReportListCoordinator: BaseCoordinator {
    
    let router: RouterProtocol
    
    private var bag = DisposeBag()
    
    init(router: RouterProtocol) {
        self.router = router
    }
    
    override func start() {
        let realm = RealmService.shared
        let vc = ReportListViewController.instantiate()
        vc.viewModelBuilder = { [bag] in
            var viewModel = ReportListViewModel(input: $0, dependencies: (realm, ()))
            viewModel.routing.tap
                .map { [weak self] in
                    self?.presentReportForm()
                }
                .drive()
                .disposed(by: bag)
            
            return viewModel
        }
        
        router.push(vc, isAnimated: false, onNavigationBack: isComplted)
    }
    
}

private extension ReportListCoordinator {
    func presentReportForm() {
        let coordinator = ReportFormCoordinator(router: router)
        self.add(coordinator)
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
