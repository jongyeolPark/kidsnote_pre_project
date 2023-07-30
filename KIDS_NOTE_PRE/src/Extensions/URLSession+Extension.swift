//
//  URLSession+Extension.swift
//  KIDS_NOTE_PRE
//
//  Created by 박종열 on 2023/07/30.
//

import Foundation
import RxSwift

extension URLSession {
    
    func execute(request: URLRequest) -> Single<Data> {
        return Single<Data>.create { observer in
            let task = self.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print(error)
                    observer(.failure(error))
                } else {
                    if let data = data {
                        observer(.success(data))
                    }
                }
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }.debug()
    }
}
