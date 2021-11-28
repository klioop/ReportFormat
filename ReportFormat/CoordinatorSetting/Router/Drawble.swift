//
//  Drwable.swift
//  HttpRouter-Coordinator-Rx
//
//  Created by klioop on 2021/11/24.
//

import UIKit

protocol Drawble {
    var viewController: UIViewController? { get }
}

extension UIViewController: Drawble {
    var viewController: UIViewController? { return self }
}
