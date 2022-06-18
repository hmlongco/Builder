//
//  Interceptors.swift
//  ViewBuilder
//
//  Created by Michael Long on 10/13/20.
//  Copyright © 2020 Michael Long. All rights reserved.
//

import Foundation
import RxSwift

class SSOAuthenticationInterceptor: ClientSessionManagerInterceptor {

    var parentSessionManager: ClientSessionManager!

    var token: String?

    init() {}

    func request(forURL url: URL?) -> URLRequest {
        var request = parentSessionManager.request(forURL: url)
        if let token = token {
            request.setValue(token, forHTTPHeaderField: "Authorization")
            print("Added authentication headers")
        }
        return request
    }

}

