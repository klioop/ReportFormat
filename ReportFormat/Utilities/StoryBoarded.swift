//
//  StoryBoarded.swift
//  ReportFormat
//
//  Created by klioop on 2021/11/28.
//

import UIKit

protocol StoryBoarded {
    static func instantiate() -> Self
}

extension StoryBoarded where Self: UIViewController {
    static func instantiate() -> Self {
        let id = String(describing: self)
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        return storyBoard.instantiateViewController(withIdentifier: id) as! Self
    }
}
