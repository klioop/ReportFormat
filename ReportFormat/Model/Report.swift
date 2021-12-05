//
//  Report.swift
//  ReportFormat
//
//  Created by klioop on 2021/12/02.
//

import Foundation

struct Report {
    let studentName: String
    let reportDate: String
    let comment: String
    let bookTitle: String?
    let bookImageUrl: String?
    let subject: String?
    let range: String?
}

extension Report {
    static func toReports(from objects: [ReportObject]) -> [Report] {
        objects.map { Report(studentName: $0.studentName, reportDate: $0.reportDate, comment: $0.comment, bookTitle: $0.bookTitle, bookImageUrl: $0.bookImageUrl, subject: $0.subject, range: $0.range) }
    }
}
