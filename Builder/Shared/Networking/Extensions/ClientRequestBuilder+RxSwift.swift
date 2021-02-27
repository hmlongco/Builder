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
        send(.get)
    }

    func post() -> Single<Data> {
        send(.post)
    }

    func put() -> Single<Data> {
        send(.put)
    }

    func create() -> Single<Data> {
        send(.create)
    }

    func delete() -> Single<Data> {
        send(.delete)
    }

    func send(_ method: HTTPMethod = .get) -> Single<Data> {
        Single.create { (single) -> Disposable in
            let task = self
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

