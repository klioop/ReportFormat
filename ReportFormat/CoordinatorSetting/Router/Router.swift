//
//  Router.swift
//  HttpRouter-Coordinator-Rx
//
//  Created by klioop on 2021/11/24.
//

import UIKit

final class Router: NSObject {
    
    private let navigationController: UINavigationController
    
    private var closures: [String: NavigationBackClosure] = [:]
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
        self.navigationController.delegate = self
        
    }
    
}

extension Router: RouterProtocol {
    
    func push(_ drawable: Drawble, isAnimated: Bool, onNavigationBack closure: NavigationBackClosure?) {
        guard let viewController = drawable.viewController else { return }
        if let closure = closure {
            closures.updateValue(closure, forKey: viewController.description)
        }
        navigationController.pushViewController(viewController, animated: isAnimated)
    }
    
    func pop(_ isAnimated: Bool) {
        navigationController.popViewController(animated: isAnimated)
    }
    
    func popToRoot(_ isAnimated: Bool) {
        navigationController.popToRootViewController(animated: isAnimated)
    }
    
    func present(_ drawable: Drawble, isAnimated: Bool, onDismiss closure: NavigationBackClosure?) {
        guard let viewController = drawable.viewController else { return }
        if let closure = closure {
            closures.updateValue(closure, forKey: viewController.description)
        }
        navigationController.present(viewController, animated: isAnimated, completion: nil)
        // To handle dismiss presentation
        viewController.presentationController?.delegate = self
    }
    
    func presentWithNav(_ nav: UINavigationController, isAnimated: Bool, onDismiss closure: NavigationBackClosure?) {
        if let closure = closure {
            closures.updateValue(closure, forKey: "nav")
        }
        navigationController.present(nav, animated: isAnimated, completion: nil)
        nav.presentationController?.delegate = self
    }
    
    func dismissWithNav(_ isAnimated: Bool) {
        navigationController.dismiss(animated: isAnimated, completion: nil)
        guard let closure = closures.removeValue(forKey: "nav") else { return }
        closure()
    }
    
    func dismiss(_ isAnimated: Bool) {
        navigationController.dismiss(animated: isAnimated, completion: nil)
        
    }
    
    func executeClosure(_ viewController: UIViewController) {
        guard let closure = closures.removeValue(forKey: viewController.description) else { return }
        closure()
    }
    
    
}

extension Router: UIAdaptivePresentationControllerDelegate {
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        executeClosure(presentationController.presentedViewController)
    }
    
}

extension Router: UINavigationControllerDelegate {
    
    // This will get called whenever the back is happening
    // Any navigation controller related things happens, it comes
    func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController, animated: Bool) {
            guard let previousController = navigationController.transitionCoordinator?.viewController(forKey: .from) else { return }
           
            // Check navigationController's viewControllers to see whether that viewController is existing there or not:
            // This case is back happening
            guard !navigationController.viewControllers.contains(previousController) else { return }
            self.executeClosure(previousController)
    }
}
