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

    var wrappedSessionManager: ClientSessionManager? { get set }
    func wrap(_ parent: ClientSessionManager) -> ClientSessionManager

    func builder(forURL url: URL?) -> ClientRequestBuilder
    func request(forURL url: URL?) -> URLRequest

    func send(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask

}

extension ClientSessionManager {
    
    func wrap(_ parent: ClientSessionManager) -> ClientSessionManager {
        parent.wrappedSessionManager = self
        return parent
    }

    func wrapper<W:ClientSessionManager>(_ handler: (_ wrapper: W) -> Void) {
        var wrapper = wrappedSessionManager
        while wrapper != nil {
            if let wrapper = wrapper as? W {
                handler(wrapper)
                return
            }
            wrapper = wrapper?.wrappedSessionManager
        }
    }

    func builder() -> ClientRequestBuilder {
        ClientRequestBuilder(self)
    }

    func builder(forURL url: URL?) -> ClientRequestBuilder {
        ClientRequestBuilder(self, forURL: url)
    }

    func request(forURL url: URL?) -> URLRequest {
        guard let wrappedSessionManager = wrappedSessionManager else {
            fatalError("request not implemented for base session manager")
        }
        return wrappedSessionManager.request(forURL: url)
    }

    func send(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask  {
        guard let wrappedSessionManager = wrappedSessionManager else {
            fatalError("send not implemented for base session manager")
        }
        return wrappedSessionManager.send(request: request, completionHandler: completionHandler)
    }

}
