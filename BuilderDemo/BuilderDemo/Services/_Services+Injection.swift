//
//  Services+Injection.swift
//  Builder
//
//  Created by Michael Long on 1/17/21.
//

import Foundation
import Factory

extension Container {
    static let userImageCache = Factory(scope: .shared) {
        UserImageCache()
    }
    static let userServiceType = Factory<UserServiceType> {
        UserService()
    }
}
