//
//  Netowrking+Injection.swift
//  Builder
//
//  Created by Michael Long on 1/17/21.
//

import UIKit
import Factory

extension Container {
    enum APIMode: String {
        case api
        case mock
        case test
    }

#if MOCK
    static var apiMode = APIMode.mock
#else
    static var apiMode = APIMode.api
#endif
}

extension Container {

    static let clientSessionManager = Factory<ClientSessionManager>(scope: .singleton) {
        switch apiMode {
        case .api:
            return clientSessionManagerAPI()
        case .mock:
            return clientSessionManagerMock()
        case .test:
            return  clientSessionManagerTest()
        }
    }

    private static let urlSession = Factory<URLSession>(scope: .singleton) {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self] // add mock protocol handler
        return URLSession(configuration: configuration)
    }

    private static let clientSessionManagerAPI = Factory<ClientSessionManager> {
        URLSessionManager(base: "https://randomuser.me/api", session: urlSession())
            .interceptor(StatusErrorMappingInterceptor())
            .interceptor(StandardHeadersInterceptor())
            .interceptor(SSOAuthenticationInterceptor())
            .interceptor(SessionLoggingInterceptor())
    }

    private static let clientSessionManagerMock = Factory<ClientSessionManager> {
        MockURLProtocol.set(forPath: "/api/portraits/men/11.jpg", status: 200, data: UIImage(named: "User-JQ")?.pngData())
        MockURLProtocol.set(forPath: "/api/portraits/med/men/11.jpg", status: 200, data: UIImage(named: "User-JQ")?.pngData())
        MockURLProtocol.set(forPath: "User-JQ", status: 200, data: UIImage(named: "User-JQ")?.pngData())
        MockURLProtocol.set(forPath: "User-TS", status: 404)
        MockURLProtocol.set(forPath: "/test", status: 200, json: "{\"name\":\"Michael\":}")
        MockURLProtocol.setupDefaultJSONBundleHandler()

        return URLSessionManager(base: "/", session: urlSession())
            .interceptor(StatusErrorMappingInterceptor())
            .interceptor(StandardHeadersInterceptor())
            .interceptor(SSOAuthenticationInterceptor())
            .interceptor(SessionLoggingInterceptor())
            .interceptor(MockDelayInterceptor(delay: 0.3))
    }

    private static let clientSessionManagerTest = Factory<ClientSessionManager> {
        URLSessionManager(base: "/", session: urlSession())
            .interceptor(StatusErrorMappingInterceptor())
            .interceptor(StandardHeadersInterceptor())
            .interceptor(SSOAuthenticationInterceptor())
            .interceptor(SessionLoggingInterceptor())
    }

}
