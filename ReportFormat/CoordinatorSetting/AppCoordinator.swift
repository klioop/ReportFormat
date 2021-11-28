//
//  AppCoordinator.swift
//  ReportFormat
//
//  Created by klioop on 2021/11/28.
//

import Foundation
import UIKit

class AppCoordinator: BaseCoordinator {
    
    private let window: UIWindow
    
    private let navigationController: UINavigationController = {
        let nav = UINavigationController()
        let navBar = nav.navigationBar
        let standardAppearnce = UINavigationBarAppearance()
        
        standardAppearnce.configureWithOpaqueBackground()
        standardAppearnce.backgroundColor = UIColor(named: "mainColor")
        standardAppearnce.titleTextAttributes = [
            .font: UIFont(name: "Avenir-Medium", size: 28.0)!,
            .foregroundColor: UIColor.white
        ]
        standardAppearnce.shadowColor = .clear
        navBar.standardAppearance = standardAppearnce
        navBar.scrollEdgeAppearance = standardAppearnce
        navBar.tintColor = .white
        navBar.isTranslucent = true
        
        return nav
    }()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() {
        let router = Router(navigationController: navigationController)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
    }
    
}

