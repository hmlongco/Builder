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
    func execute(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask

    func wrap(_ wrapper: ClientSessionManagerWrapper) -> ClientSessionManager
    func wrapper<W:ClientSessionManager>(_ handler: (_ wrapper: W) -> Void)
    
}

extension ClientSessionManager {
    
    func wrap(_ parent: ClientSessionManagerWrapper) -> ClientSessionManager {
        parent.wrappedSessionManager = self
        return parent
    }

    func wrapper<W:ClientSessionManager>(_ handler: (_ wrapper: W) -> Void) {
        if let wrapper = self as? W {
            handler(wrapper)
        }
    }

    func builder() -> ClientRequestBuilder {
        ClientRequestBuilder(self)
    }

    func builder(forURL url: URL?) -> ClientRequestBuilder {
        ClientRequestBuilder(self, forURL: url)
    }
    
}
