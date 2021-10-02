//
//  ClientSessionManagerWrapper.swift
//  ViewBuilder
//
//  Created by Michael Long on 10/19/20.
//  Copyright © 2020 Michael Long. All rights reserved.
//

import Foundation
import RxSwift


protocol ClientSessionManagerWrapper: ClientSessionManager {
    var wrappedSessionManager: ClientSessionManager! { get set }
}

extension ClientSessionManagerWrapper {
    
    func wrapper<W:ClientSessionManager>(_ handler: (_ wrapper: W) -> Void) {
        if let wrapper = self as? W {
            handler(wrapper)
            return
        }
        return wrappedSessionManager.wrapper(handler)
    }

    func request(forURL url: URL?) -> URLRequest {
        return wrappedSessionManager.request(forURL: url)
    }

    func execute(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask?  {
        return wrappedSessionManager.execute(request: request, completionHandler: completionHandler)
    }
    
}

