//
//  ReportCoordinator.swift
//  ReportFormat
//
//  Created by klioop on 2021/12/02.
//

import Foundation

class ReportCoordinator: BaseCoordinator {
    
    let router: RouterProtocol
    let report: Report
    
    init(router: RouterProtocol, report: Report) {
        self.router = router
        self.report = report
    }
    
    override func start() {
        let vc = ReportViewController.instantiate()
        vc.viewModelBuilder = { [report] in
            let viewModel = ReportViewModel(input: $0, dependencies: (report, ()))
            
            return viewModel
        }
        router.push(vc, isAnimated: true, onNavigationBack: isComplted)
    }
}
