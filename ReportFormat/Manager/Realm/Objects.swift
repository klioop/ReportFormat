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
