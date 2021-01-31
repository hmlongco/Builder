//
//  ClientSessionWrappers.swift
//  ViewBuilder
//
//  Created by Michael Long on 10/13/20.
//  Copyright © 2020 Michael Long. All rights reserved.
//

import Foundation
import RxSwift


class SessionLoggingWrapper: ClientSessionManagerType {

    var wrappedSessionManager: ClientSessionManagerType?

    init() {}

    func send(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask  {
        print(request)
        return unwrappedSessionManager.send(request: request, completionHandler: completionHandler)
    }

}

class StandardHeadersWrapper: ClientSessionManagerType {

    var wrappedSessionManager: ClientSessionManagerType?

    init() {}

    func request(forURL url: URL?) -> URLRequest {
        var request = unwrappedSessionManager.request(forURL: url)
        request.setValue("something", forHTTPHeaderField: "header")
        return request
    }

}

class SSOAuthenticationWrapper: ClientSessionManagerType {

    var wrappedSessionManager: ClientSessionManagerType?

    init() {}

    func send(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask  {
        print("authentication management stuff")
        return unwrappedSessionManager.send(request: request, completionHandler: completionHandler)
    }

}

class MemoryCacheWrapper: ClientSessionManagerType {

    var wrappedSessionManager: ClientSessionManagerType?

    init() {}

    func send(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask  {
        return unwrappedSessionManager.send(request: request, completionHandler: completionHandler)
    }

}

class ErrorMappingWrapper: ClientSessionManagerType {

    var wrappedSessionManager: ClientSessionManagerType?

    init() {}

    func send(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask  {
        return unwrappedSessionManager.send(request: request, completionHandler: completionHandler)
    }

}


