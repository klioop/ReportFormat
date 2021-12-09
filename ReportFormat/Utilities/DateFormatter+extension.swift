//
//  DateFormatter+extension.swift
//  ReportFormat
//
//  Created by klioop on 2021/12/08.
//

import Foundation

extension DateFormatter {
    static var shared: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        
        return formatter
    }
    
}
