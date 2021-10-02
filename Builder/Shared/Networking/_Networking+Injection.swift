//
//  Netowrking+Injection.swift
//  Builder
//
//  Created by Michael Long on 1/17/21.
//

import UIKit
import Resolver

extension Resolver.Name {
    #if MOCK
    static let apiMode = mock
    #else
    static let apiMode = api
    #endif

    static let api = Self("api")
    static let mock = Self("mock")
    static let test = Self("test")
}

extension Resolver {

    public static func registerNetworking() {
        
        register(ClientSessionManager.self) {
            resolve(ClientSessionManager.self, name: .apiMode)
        }

        register(ClientSessionManager.self, name: .api) {
            URLSessionManager(base: "https://randomuser.me/api", session: URLSession.shared)
                .wrap(ErrorMappingWrapper())
                .wrap(StandardHeadersWrapper())
                .wrap(SSOAuthenticationWrapper())
                .wrap(SessionLoggingWrapper())
        }
        
        register(ClientSessionManager.self, name: .mock) {
            URLSessionManager(base: "/", session: URLSession.mock)
                .wrap(ErrorMappingWrapper())
                .wrap(StandardHeadersWrapper())
                .wrap(SSOAuthenticationWrapper())
                .wrap(SessionLoggingWrapper())
                .wrap(MockDelayWrapper(delay: 0.3))
        }
        
        register(ClientSessionManager.self, name: .test) {
            URLSessionManager(base: "/", session: URLSession.mock)
                .wrap(ErrorMappingWrapper())
                .wrap(StandardHeadersWrapper())
                .wrap(SSOAuthenticationWrapper())
                .wrap(SessionLoggingWrapper())
        }
        
        registerMocks()
    }
    
    public static func registerMocks() {
        #if MOCK
        MockResponses.set(forPath: "/users", status: 200, encode: UserResultType(results: User.users))
        MockResponses.set(forPath: "/users", status: 200, file: "get_users")
        MockResponses.set(forPath: "/users", status: 404)
        MockResponses.set(forPath: "User-JQ", status: 200, data: UIImage(named: "User-JQ")?.pngData())
        MockResponses.set(forPath: "User-TS", status: 404)
        MockResponses.set(forPath: "/test", status: 200, json: "{\"name\":\"Michael\":}")
        
        MockResponses.setupDefaultJSONBundleHandler()
        #endif
    }
}
