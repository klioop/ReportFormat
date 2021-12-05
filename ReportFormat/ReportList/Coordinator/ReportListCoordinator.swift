//
//  ReportListCoordinator.swift
//  ReportFormat
//
//  Created by klioop on 2021/12/05.
//

import Foundation

class ReportListCoordinator: BaseCoordinator {
    
    let router: RouterProtocol
    
    init(router: RouterProtocol) {
        self.router = router
    }
    
    override func start() {
        let realm = RealmService.shared
        let vc = ReportListViewController.instantiate()
        vc.viewModelBuilder = {
            let viewModel = ReportListViewModel(input: $0, dependencies: (realm, ()))
            
            return viewModel
        }
        
        router.push(vc, isAnimated: false, onNavigationBack: isComplted)
    }
    
}
