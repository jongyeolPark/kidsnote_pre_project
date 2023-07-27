//
//  BookService.swift
//  KIDS_NOTE_PRE
//
//  Created by 박종열 on 2023/07/27.
//

import Foundation
import RxSwift

enum BookServiceProvider {
    case searchList(path: String, query: String)
}

protocol BookServiceProtocol: AnyObject {
    func execute<T>(_ type: T.Type, token: BookServiceProvider) -> Observable<T> where T: Decodable
}

class BookService: BookServiceProtocol {
    
    static let shared = BookService()
    
    static let baseUrl = "https://www.googleapis.com/books/v1"
    static let apiKey = "AIzaSyBMJJd51yKruxh-HdleKwilztTTLQh6geY"

    private init() { }
    
    func execute<T>(_ type: T.Type, token: BookServiceProvider) -> Observable<T> where T: Decodable {
        Observable.just(token)
            .map { token -> URL in
                var params: [URLQueryItem]
                let urlPath: String
                switch token {
                case let .searchList(path, query):
                    urlPath = path
                    params = [URLQueryItem(name: "q", value: query)]
                }
                params += [URLQueryItem(name: "key", value: BookService.apiKey)]
                var comp = URLComponents(string: "\(BookService.baseUrl)\(urlPath)")!
                params.forEach { q in
                    comp.queryItems?.append(q)
                }
                return comp.url!
            }.flatMap { url -> Observable<T> in
                return Observable<T>.create { emit in
                    Task {
                        do {
                            let (data, response) = try await URLSession.shared.data(from: url)
                            let successRange = 200..<300
                            if let statusCode = (response as? HTTPURLResponse)?.statusCode, successRange.contains(statusCode) {
                                let decoder = JSONDecoder()
                                let response = try decoder.decode(type, from: data)
                                emit.onNext(response)
                            }
                        } catch {
                            emit.onError(error)
                        }
                    }
                    return Disposables.create {
                        emit.onCompleted()
                    }
                }
            }
    }
}
