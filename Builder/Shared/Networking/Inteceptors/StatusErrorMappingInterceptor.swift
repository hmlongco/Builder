//
//  Interceptors.swift
//  ViewBuilder
//
//  Created by Michael Long on 10/13/20.
//  Copyright © 2020 Michael Long. All rights reserved.
//

import Foundation
import RxSwift

class StatusErrorMappingInterceptor: ClientSessionManagerInterceptor {

    var parentSessionManager: ClientSessionManager!

    init() {}

    func execute(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask?  {
        let interceptor: (Data?, URLResponse?, Error?) -> Void = { (data, response, error) in
            let status: Int = (response as? HTTPURLResponse)?.statusCode ?? 999
            switch status {
            case 404:
                completionHandler(data, response, APIError.unknown)
            case 500:
                completionHandler(data, response, APIError.unknown)
            default:
                completionHandler(data, response, error)
            }
        }
        return parentSessionManager.execute(request: request, completionHandler: interceptor)
    }

}
