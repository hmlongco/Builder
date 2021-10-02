//
//  MockDelayWrapper.swift
//  ViewBuilder
//
//  Created by Michael Long on 10/13/20.
//  Copyright © 2020 Michael Long. All rights reserved.
//

import Foundation

class MockDelayWrapper: ClientSessionManagerWrapper {

    var wrappedSessionManager: ClientSessionManager!
    
    static var delay: Double = 0.2

    init(delay: Double = 0.2) {
        MockDelayWrapper.delay = delay
    }

    func execute(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask?  {
        let interceptor: (Data?, URLResponse?, Error?) -> Void = { (data, response, error) in
            if MockDelayWrapper.delay > 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + MockDelayWrapper.delay) {
                    completionHandler(data, response, error)
                }
            } else {
                completionHandler(data, response, error)
            }
        }
        return wrappedSessionManager.execute(request: request, completionHandler: interceptor)
    }

}
