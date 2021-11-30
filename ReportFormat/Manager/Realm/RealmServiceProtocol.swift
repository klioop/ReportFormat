//
//  RealmServiceProtocol.swift
//  ReportFormat
//
//  Created by klioop on 2021/11/28.
//

import Foundation
import RxSwift

protocol RealmServiceProtocol {
    func getStudent(with name: String) -> Single<[StudentObject]>
    func getSubject(with name: String) -> Single<[SubjectObject]>
    func addStudent(with name: String) throws
    func addSubject(with name: String) throws
    func getAllStudents() -> Single<[StudentObject]>
    func getAllSubjects() -> Single<[SubjectObject]>
}

