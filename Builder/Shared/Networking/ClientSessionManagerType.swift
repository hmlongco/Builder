//
//  ClientSessionManagerType.swift
//  ViewBuilder
//
//  Created by Michael Long on 10/19/20.
//  Copyright © 2020 Michael Long. All rights reserved.
//

import Foundation
import RxSwift


protocol ClientSessionManagerType: AnyObject {

    var wrappedSessionManager: ClientSessionManagerType? { get set }
    func wrap(_ parent: ClientSessionManagerType) -> ClientSessionManagerType

    func builder(forURL url: URL?) -> ClientRequestBuilder
    func request(forURL url: URL?) -> URLRequest

    func send(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask

}

extension ClientSessionManagerType {

    var unwrappedSessionManager: ClientSessionManagerType {
        guard let manager = wrappedSessionManager else {
            fatalError("no base session manager found for this request")
        }
        return manager
    }

    func wrap(_ parent: ClientSessionManagerType) -> ClientSessionManagerType {
        parent.wrappedSessionManager = self
        return parent
    }

    func builder() -> ClientRequestBuilder {
        ClientRequestBuilder(self)
    }

    func builder(forURL url: URL?) -> ClientRequestBuilder {
        ClientRequestBuilder(self, forURL: url)
    }

    func request(forURL url: URL?) -> URLRequest {
        unwrappedSessionManager.request(forURL: url)
    }

    func send(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask  {
        unwrappedSessionManager.send(request: request, completionHandler: completionHandler)
    }

}
