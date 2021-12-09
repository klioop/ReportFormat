//
//  RouterProtocol.swift
//  HttpRouter-Coordinator-Rx
//
//  Created by klioop on 2021/11/24.
//

import Foundation
import UIKit

typealias NavigationBackClosure = () -> Void

protocol RouterProtocol {
    func push(_ drawable: Drawble, isAnimated: Bool, onNavigationBack: NavigationBackClosure?)
    
    func pop(_ isAnimated: Bool)
    
    func present(_ drawable: Drawble, isAnimated: Bool, onDismiss: NavigationBackClosure?)
    
    func popToRoot(_ isAnimated: Bool)
    
    func dismiss(_ isAnimated: Bool)
    
    func presentWithNav(_ nav: UINavigationController, isAnimated: Bool, onDismiss: NavigationBackClosure?)
    
    func dismissWithNav(_ isAnimated: Bool)
    
    func pushOnModal(_ drawable: Drawble, isAnimated: Bool, onNavigationBack closure: NavigationBackClosure?)
}
