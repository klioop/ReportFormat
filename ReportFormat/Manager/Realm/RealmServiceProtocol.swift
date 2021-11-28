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
}
