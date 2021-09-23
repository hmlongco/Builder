//
//  Wrappers.swift
//  ViewBuilder
//
//  Created by Michael Long on 10/13/20.
//  Copyright © 2020 Michael Long. All rights reserved.
//

import Foundation
import RxSwift


class SessionLoggingWrapper: ClientSessionManagerWrapper {

    var wrappedSessionManager: ClientSessionManager!

    init() {}

    func execute(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask  {
        print("REQ: \(request)")
        let interceptor: (Data?, URLResponse?, Error?) -> Void = { (data, response, error) in
            let status: Int = (response as? HTTPURLResponse)?.statusCode ?? 999
            print("\(status): \(request)")
            completionHandler(data, response, error)
        }
        return wrappedSessionManager.execute(request: request, completionHandler: interceptor)
    }

}
