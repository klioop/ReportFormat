//
//  BookAPIManager.swift
//  ReportFormat
//
//  Created by klioop on 2021/11/26.
//

import Foundation
import RxSwift
import Alamofire
import Network

final class BookAPIManager {
    
    private lazy var apiService = NaverAPIService()
    static let shared: BookAPIManager = .init()
    
}

extension BookAPIManager: NaverBookAPIProtocol {
    
    func fetchBooks(with query: [String: String]) -> Single<[Book]> {
        Single<[Book]>.create { [apiService] single in
            do {
                try NaverAPIRouter.getBooks
                    .request(with: apiService, parameters: query)
                    .responseJSON { result in
                        do {
                            let response = try BookAPIManager.parseBooks(from: result)
                            let books = response.items.map { Book.toBook(from: $0) }
                            single(.success(books.uniqueElements()))
                        } catch {
                            single(.failure(APIError.failedToParseJSON))
                        }
                    }
            } catch {
                single(.failure(APIError.invalidUrl))
            }
            
            return Disposables.create()
        }
    }
    
    static func parseBooks(from result: AFDataResponse<Any>) throws -> BookResponse {
        let decoder = JSONDecoder()
        guard
            let data = result.data,
            let dataParsed = try? decoder.decode(BookResponse.self, from: data)
        else {
            throw APIError.failedToParseJSON
        }
        return dataParsed
    }
}

extension Array where Element: Hashable {
    
    func uniqueElements() -> Array {
        //Create an empty Set to track unique items
        var set = Set<Element>()
        let result = self.filter {
            guard !set.contains($0) else {
                return false
            }
            set.insert($0)
            return true
        }
        return result
    }
   
}
