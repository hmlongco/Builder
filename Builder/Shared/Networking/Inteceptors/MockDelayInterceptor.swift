//
//  MockDelayInterceptor.swift
//  ViewBuilder
//
//  Created by Michael Long on 10/13/20.
//  Copyright © 2020 Michael Long. All rights reserved.
//

import Foundation

class MockDelayInterceptor: ClientSessionManagerInterceptor {

    var parentSessionManager: ClientSessionManager!
    
    static var delay: Double = 0.2

    init(delay: Double = 0.2) {
        MockDelayInterceptor.delay = delay
    }

    func execute(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask?  {
        let interceptor: (Data?, URLResponse?, Error?) -> Void = { (data, response, error) in
            if MockDelayInterceptor.delay > 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + MockDelayInterceptor.delay) {
                    completionHandler(data, response, error)
                }
            } else {
                completionHandler(data, response, error)
            }
        }
        return parentSessionManager.execute(request: request, completionHandler: interceptor)
    }
}
