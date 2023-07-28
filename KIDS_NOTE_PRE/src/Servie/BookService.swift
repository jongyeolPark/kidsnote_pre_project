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

protocol BookServiceProtocol: AnyObject {
    func execute<T>(_ type: T.Type, token: BookServiceProvider) -> Observable<T> where T: Decodable
}

enum BookServiceError: Error {
    case badUrl
    case invalidResponse
    case failed(Int)
    case invalidData
}

class BookService: BookServiceProtocol {
    
    static let shared = BookService()
    
    static let baseUrl = "https://www.googleapis.com"
    static let apiKey = "AIzaSyBMJJd51yKruxh-HdleKwilztTTLQh6geY"

    private init() { }
    
    func execute<T>(_ type: T.Type, token: BookServiceProvider) -> Observable<T> where T: Decodable {
        Observable<T>.create { emit in
            guard var urlComponents = URLComponents(string: BookService.baseUrl) else {
                emit.onError(BookServiceError.badUrl)
                return Disposables.create()
            }
            switch token {
            case let .searchList(path, query, pageNum):
                let startIndex = SearchQuery.maxResults * (pageNum - 1)
                urlComponents.path = path
                urlComponents.queryItems = [
                    URLQueryItem(name: "q", value: query),
                    URLQueryItem(name: "maxResults", value: "\(SearchQuery.maxResults)"),
                    URLQueryItem(name: "startIndex", value: "\(startIndex)"),
                ]
            }
            urlComponents.queryItems?.append(URLQueryItem(name: "key", value: BookService.apiKey))
            
            guard let url = urlComponents.url else {
                emit.onError(BookServiceError.badUrl)
                return Disposables.create()
            }
            
            Task {
                do {
                    let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
                    guard (200..<300).contains((response as? HTTPURLResponse)?.statusCode ?? 0) else {
                        emit.onError(BookServiceError.invalidResponse)
                        return
                    }
                    let result = try JSONDecoder().decode(type, from: data)
                    emit.onNext(result)
                } catch {
                    emit.onError(error)
                }
            }
            return Disposables.create {
                emit.onCompleted()
            }
        }.observe(on: MainScheduler.asyncInstance)
    }
}
