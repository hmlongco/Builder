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
        
        register(URLSession.self) {
            let configuration = URLSessionConfiguration.ephemeral
            configuration.protocolClasses = [MockURLProtocol.self] // add mock protocol handler
            return URLSession(configuration: configuration)
        }
        
        register(ClientSessionManager.self) {
            resolve(ClientSessionManager.self, name: .apiMode)
        }

        register(ClientSessionManager.self, name: .api) {
            URLSessionManager(base: "https://randomuser.me/api", session: resolve())
                .interceptor(StatusErrorMappingInterceptor())
                .interceptor(StandardHeadersInterceptor())
                .interceptor(SSOAuthenticationInterceptor())
                .interceptor(SessionLoggingInterceptor())
        }
        
//        MockURLProtocol.set(forPath: "/api", status: 200, file: "get_users")
        MockURLProtocol.set(forPath: "/api/portraits/men/11.jpg", status: 200, data: UIImage(named: "User-JQ")?.pngData())
        MockURLProtocol.set(forPath: "/api/portraits/med/men/11.jpg", status: 200, data: UIImage(named: "User-JQ")?.pngData())

        register(ClientSessionManager.self, name: .mock) {
            URLSessionManager(base: "/", session: resolve())
                .interceptor(StatusErrorMappingInterceptor())
                .interceptor(StandardHeadersInterceptor())
                .interceptor(SSOAuthenticationInterceptor())
                .interceptor(SessionLoggingInterceptor())
                .interceptor(MockDelayInterceptor(delay: 0.3))
        }
        
        register(ClientSessionManager.self, name: .test) {
            URLSessionManager(base: "/", session: resolve())
                .interceptor(StatusErrorMappingInterceptor())
                .interceptor(StandardHeadersInterceptor())
                .interceptor(SSOAuthenticationInterceptor())
                .interceptor(SessionLoggingInterceptor())
        }
        
        #if MOCK
        registerMocks()
        #endif
    }
    
    public static func registerMocks() {
//        MockURLProtocol.set(forPath: "/users", status: 200, encode: UserResultType(results: User.users))
//        MockURLProtocol.set(forPath: "/users", status: 200, file: "get_users")
//        MockURLProtocol.set(forPath: "/", status: 404)
//        MockURLProtocol.set(forPath: "/", error: .server)
        MockURLProtocol.set(forPath: "User-JQ", status: 200, data: UIImage(named: "User-JQ")?.pngData())
        MockURLProtocol.set(forPath: "User-TS", status: 404)
        MockURLProtocol.set(forPath: "/test", status: 200, json: "{\"name\":\"Michael\":}")
        
        MockURLProtocol.setupDefaultJSONBundleHandler()
    }
}
