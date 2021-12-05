//
//  Objects.swift
//  ReportFormat
//
//  Created by klioop on 2021/11/28.
//

import Foundation
import RealmSwift

class StudentObject: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
    @Persisted var dateCreated: Date
}

class SubjectObject: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
    @Persisted var dateCreated: Date
}

class ReportObject: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var studentName: String
    @Persisted var reportDate: String
    @Persisted var comment: String
    @Persisted var bookTitle: String?
    @Persisted var bookImageUrl: String?
    @Persisted var subject: String?
    @Persisted var range: String?
}
