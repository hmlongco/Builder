//
//  Wrappers.swift
//  ViewBuilder
//
//  Created by Michael Long on 10/13/20.
//  Copyright © 2020 Michael Long. All rights reserved.
//

import Foundation
import RxSwift

class StandardHeadersWrapper: ClientSessionManagerWrapper {

    var wrappedSessionManager: ClientSessionManager!
    
    init() {}

    func request(forURL url: URL?) -> URLRequest {
        var request = wrappedSessionManager.request(forURL: url)
        request.setValue("something", forHTTPHeaderField: "header")
        print("Added standard headers")
        return request
    }

}
