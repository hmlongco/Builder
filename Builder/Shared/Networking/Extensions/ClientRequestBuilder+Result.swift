//
//  ClientRequestBuilder+Result.swift
//  ViewBuilder
//
//  Created by Michael Long on 10/20/20.
//  Copyright © 2020 Michael Long. All rights reserved.
//

import Foundation


extension ClientRequestBuilder {

//    struct ResultExtension {
//
//        let builder: ClientRequestBuilder
//
//        func send<ResultType:Decodable>(_ method: HTTPMethod, completionHandler: @escaping (_ result: Result<ResultType, APIError>) -> Void) -> Void {
//            builder
//                .method(method)
//                .send { (data, _, error) in
//                    if let data = data, let result = try? JSONDecoder().decode(ResultType.self, from: data) {
//                        completionHandler(.success(result))
//                    } else {
//                        completionHandler(.failure(error as? APIError ?? .application))
//                    }
//                }
//                .resume()
//        }
//
//        func send(_ method: HTTPMethod, completionHandler: @escaping (_ result: Result<Data, APIError>) -> Void) -> Void {
//            builder
//                .method(method)
//                .send { (data, _, error) in
//                    if let data = data {
//                        completionHandler(.success(data))
//                    } else {
//                        completionHandler(.failure(error as? APIError ?? .application))
//                    }
//                }
//                .resume()
//        }
//        
//    }
//
//    var result: ResultExtension {
//        ResultExtension(builder: self)
//    }

}
