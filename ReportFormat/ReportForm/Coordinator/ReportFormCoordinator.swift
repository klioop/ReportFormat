//
//  ReportFormCoordinator.swift
//  ReportFormat
//
//  Created by klioop on 2021/11/29.
//

import Foundation
import RxSwift

class ReportFormCoordinator: BaseCoordinator {
    
    let router: RouterProtocol
    
    private let bag = DisposeBag()
    
    init(router: RouterProtocol) {
        self.router = router
    }
    
    override func start() {
        let vc = ReportFormViewController.instantiate()
        let apiService = BookAPIManager.shared
        let realmService = RealmService.shared
        
        vc.viewModelBuilder = { [bag] in
            var viewModel = ReportFormViewModel(
                date: .date(),
                student: .student(),
                subject: .subject(),
                book: .book(),
                range: .range(),
                comment: .comment(),
                buttonViewModel: ButtonViewModel(),
                realmService: realmService,
                bookService: apiService
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
        let reportCoordinator = ReportCoordinator(router: router, report: report)
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

