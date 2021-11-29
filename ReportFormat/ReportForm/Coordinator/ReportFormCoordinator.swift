//
//  ReportFormCoordinator.swift
//  ReportFormat
//
//  Created by klioop on 2021/11/29.
//

import Foundation

class ReportFormCoordinator: BaseCoordinator {
    
    let router: RouterProtocol
    
    init(router: RouterProtocol) {
        self.router = router
    }
    
    override func start() {
        let vc = ReportFormViewController.instantiate()
        let apiService = BookAPIManager.shared
        let realmService = RealmService.shared
        vc.viewModelBuilder = {
            let viewModel = ReportFormViewModel(
                date: .date(),
                student: .student(),
                subject: .subject(),
                book: .book(),
                range: .range(),
                comment: .comment(),
                button: ButtonViewModel(),
                realmService: realmService,
                bookService: apiService
            )
            return viewModel
        }
        router.push(vc, isAnimated: true, onNavigationBack: isComplted)
    }
    
}
