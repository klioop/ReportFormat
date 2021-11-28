//
//  BaseCoordinator.swift
//  ReportFormat
//
//  Created by klioop on 2021/11/28.
//

import Foundation

class BaseCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var isComplted: (() -> Void)?
    
    func start() {
        fatalError("Children should implemnt 'start'.")
    }
    
}
