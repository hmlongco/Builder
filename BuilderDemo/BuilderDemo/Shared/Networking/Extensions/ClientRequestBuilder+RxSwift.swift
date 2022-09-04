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
    
    func get() -> Single<Data> {
        execute(.get)
    }

    func post() -> Single<Data> {
        execute(.post)
    }

    func put() -> Single<Data> {
        execute(.put)
    }

    func create() -> Single<Data> {
        execute(.create)
    }

    func delete() -> Single<Data> {
        execute(.delete)
    }

    func execute(_ method: HTTPMethod = .get) -> Single<Data> {
        execute(method)
            .map { (data, response, error) -> Data in
                if let error = error {
                    throw error //as? APIError ?? .unexpected
                } else {
                    return data ?? Data()
                }
            }
    }

    func execute(_ method: HTTPMethod = .get) -> Single<(Data?, URLResponse?, Error?)> {
        Single.create { (single) -> Disposable in
            let task = self
                .method(method)
                .execute { (data, response, error) in
                    single(.success((data, response, error)))
                }
            task?.resume()
            return Disposables.create { task?.cancel() }
        }
    }

//    struct RxExtension {
//
//        let builder: ClientRequestBuilder
//
//        func send(_ method: HTTPMethod = .get) -> Single<Data> {
//            Single.create { (single) -> Disposable in
//                let task = builder
//                    .method(method)
//                    .send { (data, _, error) in
//                        if let data = data {
//                            single(.success(data))
//                        } else {
//                            single(.failure(error as? APIError ?? .unexpected))
//                        }
//                    }
//                task.resume()
//                return Disposables.create { task.cancel() }
//            }
//        }
//
//    }
//
//    var rx: RxExtension {
//        RxExtension(builder: self)
//    }

}


public extension Single where Element == Data, Trait == SingleTrait {
    func decode<Item: Decodable, Decoder: DataDecoder>(type: Item.Type, decoder: Decoder) -> Single<Item> {
        map { try decoder.decode(type, from: $0) }
    }
}

