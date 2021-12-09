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
    var report: Report?
    let sceneType: ReportFormSceneType
    
    let reportEditted: PublishRelay<Report>?
    
    private let bag = DisposeBag()
    private let didDismss = PublishRelay<Void>()
    
    
    
    init(
        router: RouterProtocol,
        sceneType: ReportFormSceneType,
        report: Report? = nil,
        reportEditted: PublishRelay<Report>? = nil
    ) {
        self.router = router
        self.report = report
        self.sceneType = sceneType
        self.reportEditted = reportEditted
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
                buttonViewModel: ButtonViewModel(sceneType: sceneType),
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
            
            viewModel.routing.reportEditted
                .map { [weak self] (report) in
                    if let reportEditted = self?.reportEditted {
                        reportEditted.accept(report)
                    }
                    self?.popTowardReport()
                }
                .drive()
                .disposed(by: bag)
            
            return viewModel
        }
        switch sceneType {
        case .new:
            let nav = createNav(with: vc)
            router.present(nav, isAnimated: true, onDismiss: isComplted)
        case .editing:
            router.push(vc, isAnimated: true, onNavigationBack: isComplted)
        }
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
    
    func popTowardReport() {
        router.pop(true)
    }
    
    func createNav(with rootViewController: UIViewController) -> UINavigationController {
        let nav: UINavigationController = {
            let nav = UINavigationController(rootViewController: rootViewController)
            let navBar = nav.navigationBar
            let standardAppearnce = UINavigationBarAppearance()
            
            standardAppearnce.configureWithOpaqueBackground()
            standardAppearnce.backgroundColor = UIColor(named: "mainColor")
            standardAppearnce.titleTextAttributes = [
                .font: UIFont(name: "Cafe24Ssurroundair", size: 25.0)!,
                .foregroundColor: UIColor.white
            ]
            standardAppearnce.shadowColor = .clear
            navBar.standardAppearance = standardAppearnce
            navBar.scrollEdgeAppearance = standardAppearnce
            navBar.tintColor = .white
            navBar.isTranslucent = true
            
            return nav
        }()
        return nav
    }
}


