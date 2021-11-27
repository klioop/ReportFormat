//
//  BookAPIManager.swift
//  ReportFormat
//
//  Created by klioop on 2021/11/26.
//

import Foundation
import RxSwift
import Alamofire

final class BookAPIManager {
    
    private lazy var apiService = NaverAPIService()
    static let shared: BookAPIManager = .init()
    
}

extension BookAPIManager: NaverBookAPIProtocol {
    
    func fetchBooks(with query: [String: String]) -> Single<ResponseOfBooks> {
        Single<ResponseOfBooks>.create { [apiService] single in
            do {
                try NaverAPIRouter.getBooks
                    .request(with: apiService, parameters: query)
                    .responseJSON { result in
                        do {
                            let books = try BookAPIManager.parseBooks(from: result)
                            single(.success(books.items))
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
