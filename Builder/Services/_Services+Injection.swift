//
//  Services+Injection.swift
//  Builder
//
//  Created by Michael Long on 1/17/21.
//

import Foundation
import Resolver

extension Resolver.Name {
    #if MOCK
    static let apiMode = mock
    #else
    static let apiMode = api
    #endif

    static let api = Self("api")
    static let mock = Self("mock")
}

extension Resolver {
    public static func registerServices() {
        register {
            return RandomUserSessionManager()
                .wrap(ErrorMappingWrapper())
                .wrap(StandardHeadersWrapper())
                .wrap(SSOAuthenticationWrapper())
                .wrap(SessionLoggingWrapper())
        }

        register { UserImageCache() }.scope(.shared)

        #if MOCK
        register { MockUserService() as UserServiceType }
        #else
        register { UserService() as UserServiceType }
        #endif

//        register { resolve(name: .apiMode) as UserServiceType }
//        register(name: .api) { UserService() as UserServiceType }
//        register(name: .mock) { MockUserService() as UserServiceType }
    }
}
