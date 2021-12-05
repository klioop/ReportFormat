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
        ["수학", "영어", "국어", "과학", "코딩"].forEach {
            if self.isSubjectExisted(with: $0) {
                try! self.addSubject(with: $0)
            }
        }
    }

}

extension RealmService: RealmServiceProtocol {
    
    func addReport(_ report: Report) throws {
        do {
            try localRealm.write {
                let reportObject = ReportObject(value: [
                    "studentName": report.studentName,
                    "reportDate": report.reportDate,
                    "comment": report.comment,
                    "bookTitle": report.bookTitle,
                    "bookImageUrl": report.bookImageUrl,
                    "subject": report.subject,
                    "range": report.range
                ])
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
