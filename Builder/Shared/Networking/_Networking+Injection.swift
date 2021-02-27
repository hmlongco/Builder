//
//  Netowrking+Injection.swift
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
    public static func registerNetworking() {
        register(ClientSessionManager.self) {
            let manager = RandomUserSessionManager()
                .wrap(ErrorMappingWrapper())
                .wrap(StandardHeadersWrapper())
                .wrap(SSOAuthenticationWrapper())
                .wrap(SessionLoggingWrapper())
            return manager
        }
    }
}
