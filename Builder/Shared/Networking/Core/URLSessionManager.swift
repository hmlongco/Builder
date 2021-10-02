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
    var session: URLSession
    
    init(base: String, session: URLSession = URLSession.shared) {
        self.base = base
        self.session = session
    }

    func request(forURL url: URL?) -> URLRequest {
        URLRequest(url: url ?? URL(string: base)!)
    }

    func execute(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask? {
        session.dataTask(with: request, completionHandler: completionHandler)
    }

}

