//
//  ReportCellViewModel.swift
//  ReportFormat
//
//  Created by klioop on 2021/12/02.
//

import Foundation

enum ReportCellCase {
    case data
    case comment
}


struct ReportCellViewModel {
    let studentName: String
    let date: String
    let comment: String
    let subject: String?
    let bookTitle: String?
    let bookImageUrl: String?
}

extension ReportCellViewModel {
    
    init(with report: Report) {
        self.studentName = report.studentName
        self.date = report.reportDate
        self.comment = report.comment
        self.subject = report.subject
        self.bookTitle = report.bookTitle
        self.bookImageUrl = report.bookImageUrl
    }
}
