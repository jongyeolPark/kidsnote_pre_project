//
//  BookService.swift
//  KIDS_NOTE_PRE
//
//  Created by 박종열 on 2023/07/27.
//

import Foundation
import RxSwift

enum BookServiceProvider {
    case searchList(query: String)
}

protocol BookServiceProtocol: AnyObject {
    
}

class BookService: BookServiceProtocol {
    
    static let shared = BookService()
    
    private init() { }
    
    func execute<T>(_ type: T.Type, token: BookServiceProvider) -> Observable<T> where T: Decodable {
        Observable.just(token)
            .map { token -> [URLQueryItem] in
                switch token {
                case .searchList(let query):
                    return [URLQueryItem(name: "q", value: query)]
                }
            }.map { query -> URL in
                var comp = URLComponents(string: "https://itunes.apple.com/search?")!
                query.forEach { q in
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
