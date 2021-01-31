//
//  ClientRequestBuilder+RX.swift
//  ViewBuilder
//
//  Created by Michael Long on 10/20/20.
//  Copyright © 2020 Michael Long. All rights reserved.
//

import Foundation
import RxSwift

extension ClientRequestBuilder {

    struct RxExtension {

        let builder: ClientRequestBuilder

        func send<ResultType:Decodable>(_ method: HTTPMethod = .get) -> Single<ResultType> {
            send(method)
                .map { (data: Data) -> ResultType in
                    try JSONDecoder().decode(ResultType.self, from: data)
                }
                .catch { (error) in
                    .error(error as? APIError ?? .application)
                }
        }

        func send(_ method: HTTPMethod = .get) -> Single<Data> {
            Single.create { (single) -> Disposable in
                let task = builder
                    .method(method)
                    .send { (data, _, error) in
                        if let data = data {
                            single(.success(data))
                        } else {
                            single(.failure(error as? APIError ?? .unexpected))
                        }
                    }
                task.resume()
                return Disposables.create { task.cancel() }
            }
        }
        
    }

    var rx: RxExtension {
        RxExtension(builder: self)
    }

}
