//
//  ClientSessionManager.swift
//  ViewBuilder
//
//  Created by Michael Long on 10/19/20.
//  Copyright © 2020 Michael Long. All rights reserved.
//

import Foundation

class MockSessionManagerWrapper: ClientSessionManagerWrapper {
    
    var wrappedSessionManager: ClientSessionManager!
    var session = URLSession.mock
    
    func request(forURL url: URL?) -> URLRequest {
        wrappedSessionManager.request(forURL: url)
    }

    func execute(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask? {
        if let path = request.url?.path, MockURLProtocol.responses[path] != nil {
            return session.dataTask(with: request, completionHandler: completionHandler)
        }
        return wrappedSessionManager.execute(request: request, completionHandler: completionHandler)
    }
}

