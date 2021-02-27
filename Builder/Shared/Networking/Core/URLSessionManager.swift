//
//  ClientSessionManager.swift
//  ViewBuilder
//
//  Created by Michael Long on 10/19/20.
//  Copyright © 2020 Michael Long. All rights reserved.
//

import Foundation

class URLSessionManager: ClientSessionManager {

    var base: String
    var wrappedSessionManager: ClientSessionManager?
    
    init(base: String) {
        self.base = base
    }

    func request(forURL url: URL?) -> URLRequest {
        URLRequest(url: url ?? URL(string: base)!)
    }

    func send(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        URLSession.shared.dataTask(with: request, completionHandler: completionHandler)
    }

}
