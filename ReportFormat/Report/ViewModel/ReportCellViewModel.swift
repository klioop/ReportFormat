//
//  ReportCellViewModel.swift
//  ReportFormat
//
//  Created by klioop on 2021/12/02.
//

import Foundation

enum ReportCellModelCase {
    case data(ReportCellViewModel)
    case comment(ReportCellViewModel)
}


struct ReportCellViewModel {
    let studentName: String
    let date: Date
    let comment: String
    let subject: String?
    let bookTitle: String?
    let bookImageUrl: String?
    let range: String?
}

extension ReportCellViewModel {
    
    init(with report: Report) {
        self.studentName = report.studentName
        self.date = report.reportDate
        self.comment = report.comment
        self.subject = report.subject
        self.bookTitle = report.bookTitle
        self.bookImageUrl = report.bookImageUrl
        self.range = report.range
    }
}
