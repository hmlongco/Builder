//
//  Wrappers.swift
//  ViewBuilder
//
//  Created by Michael Long on 10/13/20.
//  Copyright © 2020 Michael Long. All rights reserved.
//

import Foundation
import RxSwift

class ErrorMappingWrapper: ClientSessionManagerWrapper {

    var wrappedSessionManager: ClientSessionManager!

    init() {}

    func execute(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask  {
        return wrappedSessionManager.execute(request: request, completionHandler: completionHandler)
    }

}
