//
//  RouterProtocol.swift
//  HttpRouter-Coordinator-Rx
//
//  Created by klioop on 2021/11/24.
//

import Foundation

typealias NavigationBackClosure = () -> Void

protocol RouterProtocol {
    func push(_ drawable: Drawble, isAnimated: Bool, onNavigationBack: NavigationBackClosure?)
    
    func pop(_ isAnimated: Bool)
    
    func present(_ drawable: Drawble, isAnimated: Bool, onDismiss: NavigationBackClosure?)
    
    func popToRoot(_ isAnimated: Bool) 
}
