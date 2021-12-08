//
//  RealmService.swift
//  ReportFormat
//
//  Created by klioop on 2021/11/28.
//

import Foundation
import RealmSwift
import RxSwift

class RealmService {
    static let shared: RealmServiceProtocol = RealmService()
    private let localRealm = try! Realm()
    
    init() {
        [
            "수학", "영어", "국어", "과학", "사회", "역사", "경제", "제 2 외국어", "Swift", "Python", "JavaScript", "NodeJS", "React", "코딩"
        ].forEach {
            if self.isSubjectExisted(with: $0) {
                try! self.addSubject(with: $0)
            }
        }
    }

}

extension RealmService: RealmServiceProtocol {
    
    func removeReport(_ index: Int) throws {
        do {
            try localRealm.write {
                let reports = getReports()
                let reportToDelete = reports[index]
                localRealm.delete(reportToDelete)
            }
        } catch {
            let error = RealmError.failedToDelete
            print(error.errorMessage)
            throw error
        }
    }
    
    func editReport(_ report: Report) throws {
        do {
            try localRealm.write {
                guard let reportObject = getReports().filter({ $0._id == report.objectId }).first else { return }
                reportObject.reportDate = report.reportDate
                reportObject.studentName = report.studentName
                reportObject.comment = report.comment
                reportObject.subject = report.subject
                reportObject.bookTitle = report.bookTitle
                reportObject.range = report.range
            }
        } catch {
            let error = RealmError.failedToEdit
            print(error.errorMessage)
            throw error
        }
    }
    
    func getReports() -> Results<ReportObject> {
        localRealm.objects(ReportObject.self).sorted(byKeyPath: "reportDate", ascending: false)
    }
    
    func getAllReports() -> Single<[ReportObject]> {
        .just(localRealm.objects(ReportObject.self).sorted(byKeyPath: "reportDate").toArray())
    }

    func addReport(_ report: Report) throws {
        do {
            try localRealm.write {
                let reportObject = RealmService.toReportObject(from: report)
                localRealm.add(reportObject)
            }
        } catch {
            let error = RealmError.failedToAddObject
            print(error.errorMessage)
            throw error
        }
    }
    
    func isSubjectExisted(with name: String) -> Bool {
        localRealm.objects(SubjectObject.self).filter("name CONTAINS %@", "\(name)").isEmpty
    }
    
    func getAllStudents() -> Single<[StudentObject]> {
        .just(localRealm.objects(StudentObject.self).sorted(byKeyPath: "name").toArray())
    }
    
    func getStudent(with name: String) -> Single<[StudentObject]> {
        let studentObjects = localRealm.objects(StudentObject.self).filter("name CONTAINS %@", "\(name)")
        return .just(studentObjects.toArray())
    }
    
    func getAllSubjects() -> Single<[SubjectObject]> {
        .just(localRealm.objects(SubjectObject.self).sorted(byKeyPath: "name").toArray())
    }
    
    func getSubject(with name: String) -> Single<[SubjectObject]> {
        let subjectObjects = localRealm.objects(SubjectObject.self).filter("name CONTAINS %@", "\(name)")
        return .just(subjectObjects.toArray())
    }
    
    func addStudent(with name: String) throws {
        do {
            try localRealm.write {
                let student = StudentObject(value: ["name": name, "dateCreated": Date()])
                localRealm.add(student)
            }
        } catch {
            let error = RealmError.failedToAddObject
            print(error.errorMessage)
            throw error
        }
    }
    
    func addSubject(with name: String) throws {
        do {
            try localRealm.write {
                let subject = SubjectObject(value: ["name": name, "dateCreated": Date()])
                localRealm.add(subject)
            }
        } catch {
            let error = RealmError.failedToAddObject
            print(error.errorMessage)
            throw error
        }
    }
}

extension Results {
    func toArray() -> Array<Self.Element> {
        self.map { $0 }
    }
}

private extension RealmService {
    static func toReportObject(from report: Report) -> ReportObject {
        ReportObject(value: [
            "studentName": report.studentName,
            "reportDate": report.reportDate,
            "comment": report.comment,
            "bookTitle": report.bookTitle,
            "bookImageUrl": report.bookImageUrl,
            "subject": report.subject,
            "range": report.range
        ])
    }
}
