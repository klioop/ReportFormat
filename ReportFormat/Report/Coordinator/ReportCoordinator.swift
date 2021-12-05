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
//    let didDismiss: PublishRelay<Void>
    
    private var bag = DisposeBag()
    
    init(
        router: RouterProtocol,
        report: Report
//        didDismiss: PublishRelay<Void>
    ) {
        self.router = router
        self.report = report
//        self.didDismiss = didDismiss
    }
    
    override func start() {
        let vc = ReportViewController.instantiate()
        let realmService = RealmService.shared
    
        vc.viewModelBuilder = { [report, realmService, bag] in
            var viewModel = ReportViewModel(
                input: $0,
                dependencies: (report, realmService)
            )
            
            viewModel.routing.didTapCreateButton
                .map { [weak self] in
//                    self.didDismiss.accept(())
                    self?.dismiss()
                }
                .drive()
                .disposed(by: bag)
            
            return viewModel
        }
        router.push(vc, isAnimated: true, onNavigationBack: isComplted)
    }
}

private extension ReportCoordinator {
    func dismiss() {
        router.popToRoot(true)
    }

}
