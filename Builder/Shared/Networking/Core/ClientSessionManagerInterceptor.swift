//
//  ClientSessionManagerInterceptor.swift
//  ViewBuilder
//
//  Created by Michael Long on 10/19/20.
//  Copyright © 2020 Michael Long. All rights reserved.
//

import Foundation
import RxSwift


protocol ClientSessionManagerInterceptor: ClientSessionManager {
    var parentSessionManager: ClientSessionManager! { get set }
}

extension ClientSessionManagerInterceptor {
    
    func configure<T:ClientSessionManager>(_ handler: (_ manager: T) -> Void) {
        if let manager = self as? T {
            handler(manager)
            return
        }
        return parentSessionManager.configure(handler)
    }

    func request(forURL url: URL?) -> URLRequest {
        return parentSessionManager.request(forURL: url)
    }

    func execute(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask?  {
        return parentSessionManager.execute(request: request, completionHandler: completionHandler)
    }
    
}

