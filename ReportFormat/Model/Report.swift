//
//  Report.swift
//  ReportFormat
//
//  Created by klioop on 2021/12/02.
//

import Foundation
import RealmSwift

struct Report {
    var studentName: String
    var reportDate: Date
    var comment: String
    var bookTitle: String?
    var bookImageUrl: String?
    var subject: String?
    var range: String?
    var objectId: ObjectId? = nil
}

extension Report {
    static func toReports(from objects: [ReportObject]) -> [Report] {
        objects.map { Report(studentName: $0.studentName, reportDate: $0.reportDate, comment: $0.comment, bookTitle: $0.bookTitle, bookImageUrl: $0.bookImageUrl, subject: $0.subject, range: $0.range, objectId: $0._id) }
    }
    
    static func emptyReport() -> Report {
        Report(studentName: "", reportDate: Date(), comment: "", bookTitle: "", bookImageUrl: "", subject: "", range: "")
    }
    
    static func toReport(from object: ReportObject) -> Report {
        Report(studentName: object.studentName, reportDate: object.reportDate, comment: object.comment, bookTitle: object.bookTitle, bookImageUrl: object.bookImageUrl, subject: object.subject, range: object.range, objectId: object._id)
    }
}
