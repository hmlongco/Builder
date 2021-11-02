//
//  Interceptors.swift
//  ViewBuilder
//
//  Created by Michael Long on 10/13/20.
//  Copyright © 2020 Michael Long. All rights reserved.
//

import Foundation
import RxSwift

class StandardHeadersInterceptor: ClientSessionManagerInterceptor {

    var parentSessionManager: ClientSessionManager!
    
    init() {}

    func request(forURL url: URL?) -> URLRequest {
        var request = parentSessionManager.request(forURL: url)
        request.setValue("something", forHTTPHeaderField: "header")
        print("Added standard headers")
        return request
    }

}
