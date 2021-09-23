//
//  Wrappers.swift
//  ViewBuilder
//
//  Created by Michael Long on 10/13/20.
//  Copyright © 2020 Michael Long. All rights reserved.
//

import Foundation
import RxSwift

class SSOAuthenticationWrapper: ClientSessionManagerWrapper {

    var wrappedSessionManager: ClientSessionManager!

    var token: String?

    init() {}

    func request(forURL url: URL?) -> URLRequest {
        var request = wrappedSessionManager.request(forURL: url)
        if let token = token {
            request.setValue(token, forHTTPHeaderField: "Authorization")
            print("Added authentication headers")
        }
        return request
    }

}

