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
    
    private var apiService = NaverAPIService()
    public let shared: BookAPIManager = .init()
    
}

extension BookAPIManager: NaverBookAPIProtocol {
    
    func fetchBooks() -> Single<BookApiResponse> {
        Single<BookApiResponse>.create { [apiService] single in
            do {
                try NaverAPIRouter.getBooks
                    .request(with: apiService)
                    .responseJSON(completionHandler: { result in
                        do {
                            let books = try BookAPIManager.parseJSON(from: result)
                            single(.success(books))
                        } catch {
                            single(.failure(error))
                        }
                    })
            } catch {
                single(.failure(APIError.invalidUrl))
            }
            return Disposables.create()
        }
    }
    
    static func parseJSON(from result: AFDataResponse<Any>) throws -> BookApiResponse {
        let decoder = JSONDecoder()
        guard
            let data = result.data,
            let dataParsed = try? decoder.decode(BookApiResponse.self, from: data)
        else {
            throw APIError.failedToParseJSON
        }
        return dataParsed
    }
}
