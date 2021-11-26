//
//  NaverBookAPIProtocol.swift
//  ReportFormat
//
//  Created by klioop on 2021/11/26.
//

import Foundation
import RxSwift

protocol NaverBookAPIProtocol {
    func fetchBooks() -> Single<BookResponse>
}
