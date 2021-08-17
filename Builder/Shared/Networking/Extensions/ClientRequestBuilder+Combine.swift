//
//  ClientRequestBuilder+RX.swift
//  ViewBuilder
//
//  Created by Michael Long on 10/20/20.
//  Copyright © 2020 Michael Long. All rights reserved.
//

import Foundation
import Combine

//extension ClientRequestBuilder {
//
//    struct CombineExtension {
//
//        let builder: ClientRequestBuilder
//
//        func send<ResultType:Decodable>(_ method: HTTPMethod = .get) -> AnyPublisher<ResultType, APIError> {
//            send(method)
//                .decode(type: ResultType.self, decoder: JSONDecoder())
//                .mapError { (error) -> APIError in
//                    error as? APIError ?? .application
//                }
//                .eraseToAnyPublisher()
//        }
//
//        func send(_ method: HTTPMethod = .get) -> AnyPublisher<Data, APIError> {
//            let publisher = PassthroughSubject<Data, APIError>()
//            let task = builder
//                .method(method)
//                .send { (data, _, error) in
//                    if let data = data {
//                        publisher.send(data)
//                    } else {
//                        publisher.send(completion: .failure(error as? APIError ?? .unexpected))
//                    }
//                }
//            task.resume()
//            return publisher.eraseToAnyPublisher()
//        }
//
//    }
//
//    var combine: CombineExtension {
//        CombineExtension(builder: self)
//    }
//
//}
