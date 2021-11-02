//
//  ClientSessionManager.swift
//  ViewBuilder
//
//  Created by Michael Long on 10/19/20.
//  Copyright © 2020 Michael Long. All rights reserved.
//

import Foundation
import RxSwift


protocol ClientSessionManager: AnyObject {

    func builder(forURL url: URL?) -> ClientRequestBuilder
    
    func request(forURL url: URL?) -> URLRequest
    func execute(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask?

    func interceptor(_ interceptor: ClientSessionManagerInterceptor) -> ClientSessionManager
    func configure<T:ClientSessionManager>(_ handler: (_ interceptor: T) -> Void)
    
}

extension ClientSessionManager {
    
    func interceptor(_ parent: ClientSessionManagerInterceptor) -> ClientSessionManager {
        parent.parentSessionManager = self
        return parent
    }

    func configure<T:ClientSessionManager>(_ handler: (_ manager: T) -> Void) {
        if let manager = self as? T {
            handler(manager)
        }
    }

    func builder() -> ClientRequestBuilder {
        ClientRequestBuilder(self)
    }

    func builder(forURL url: URL?) -> ClientRequestBuilder {
        ClientRequestBuilder(self, forURL: url)
    }
    
}
