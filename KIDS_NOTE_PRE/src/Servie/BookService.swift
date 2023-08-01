//
//  BookService.swift
//  KIDS_NOTE_PRE
//
//  Created by 박종열 on 2023/07/27.
//

import Foundation
import RxSwift

enum BookServiceProvider {
    case searchList(path: String = "/books/v1/volumes", query: String, pageNum: Int)
}

class URLBuilder {
    
    static let shared: URLBuilder = URLBuilder()
    
    private let baseUrl = "https://www.googleapis.com"
    
    private let apiKey = "AIzaSyBMJJd51yKruxh-HdleKwilztTTLQh6geY"

    private init() { }
    
    func build(provider: BookServiceProvider) -> URL? {
        var urlComponents = URLComponents(string: baseUrl)
        switch provider {
        case let .searchList(path, query, pageNum):
            let startIndex = SearchQuery.maxResults * (pageNum - 1)
            urlComponents?.path = path
            urlComponents?.queryItems = [
                URLQueryItem(name: "q", value: query),
                URLQueryItem(name: "maxResults", value: "\(SearchQuery.maxResults)"),
                URLQueryItem(name: "startIndex", value: "\(startIndex)"),
            ]
        }
        urlComponents?.queryItems?.append(URLQueryItem(name: "key", value: apiKey))
        return urlComponents?.url
    }
}

protocol BookServiceProtocol: AnyObject {
    func execute<T>(_ type: T.Type, token: BookServiceProvider) -> Observable<T> where T: Decodable
}

enum ApiServiceError: Error {
    case timeout
    case failed(Int)
    case invalidResponse
    case parseError
}

class BookService: BookServiceProtocol {
    
    static let shared = BookService()
    
    private init() { }
    
    func execute<T>(_ type: T.Type, token: BookServiceProvider) -> Observable<T> where T: Decodable {
        guard let url = URLBuilder.shared.build(provider: token) else {
            return .empty()
        }
        
        return URLSession.shared.execute(request: URLRequest(url: url))
            .map { try JSONDecoder().decode(type, from: $0) }
            .asObservable()
    }
}
