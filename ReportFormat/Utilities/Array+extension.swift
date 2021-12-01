//
//  Array+extension.swift
//  ReportFormat
//
//  Created by klioop on 2021/12/01.
//

import Foundation


extension Array where Element: Hashable {
    
    func uniqueElements() -> Array {
        //Create an empty Set to track unique items
        var set = Set<Element>()
        let result = self.filter {
            guard !set.contains($0) else {
                return false
            }
            set.insert($0)
            return true
        }
        return result
    }
}


