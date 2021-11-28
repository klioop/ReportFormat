//
//  RealmService.swift
//  ReportFormat
//
//  Created by klioop on 2021/11/28.
//

import Foundation
import RealmSwift
import RxSwift

class RealmService: RealmServiceProtocol {
    let localRealm = try! Realm()

    func getStudent(with name: String) -> Single<[StudentObject]> {
        let studentObjects = localRealm.objects(StudentObject.self).filter("name CONTAINS %@", "\(name)")
        return .just(studentObjects.toArray())
    }
    
    func getSubject(with name: String) -> Single<[SubjectObject]> {
        let subjectObjects = localRealm.objects(SubjectObject.self).filter("name CONTAINS %@", "\(name)")
        return .just(subjectObjects.toArray())
    }
    
}

extension Results {
    func toArray() -> Array<Self.Element> {
        self.map { $0 }
    }
        
}
