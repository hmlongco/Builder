//
//  Wrappers.swift
//  ViewBuilder
//
//  Created by Michael Long on 10/13/20.
//  Copyright © 2020 Michael Long. All rights reserved.
//

import Foundation
import RxSwift

class ErrorMappingWrapper: ClientSessionManager {

    var wrappedSessionManager: ClientSessionManager?

    init() {}

    func send(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask  {
        return wrappedSessionManager!.send(request: request, completionHandler: completionHandler)
    }

}
