//
//  Coordinator.swift
//  ReportFormat
//
//  Created by klioop on 2021/11/28.
//

import Foundation

protocol Coordinator: AnyObject {
    
    var childCoordinators: [Coordinator] { get set }
    
    func start()
}

extension Coordinator {
    
    func add(_ coordinator: Coordinator) -> Void {
        childCoordinators.append(coordinator)
    }
    
    func remove(_ coordinator: Coordinator) -> Void {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }

}
