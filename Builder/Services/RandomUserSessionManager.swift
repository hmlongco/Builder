//
//  RandomUserSessionManager.swift
//  Builder
//
//  Created by Michael Long on 1/18/21.
//

import Foundation

class RandomUserSessionManager: URLSessionManager {
    init() {
        super.init(base: "https://randomuser.me/api")
    }
}
