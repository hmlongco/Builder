//
//  MockURLProtocol.swift
//  Builder
//
//  Created by Michael Long on 9/30/21.
//

import Foundation

struct MockResponses {
    
    static var responses: [String:(_ request: URLRequest) -> (Int,Data?)] = [:]
    
    static func set(forPath path: String, response: @escaping (_ request: URLRequest) -> (Int,Data?)) {
        defer { lock.unlock() }
        lock.lock()
        responses[path] = response
    }
    
    static func set(forPath path: String, status: Int, data: Data? = nil) {
        set(forPath: path) { _ in
            (status, data)
        }
    }
    
    static func set<T:Codable>(forPath path: String, status: Int, encode object: T) {
        set(forPath: path) { _ in
            guard let data = try? JSONEncoder().encode(object) else {
                return (500, nil)
            }
            return (status, data)
        }
    }
    
    static func set(forPath path: String, status: Int, file: String) {
        set(forPath: path) { _ in
            guard let filePath = Bundle.main.url(forResource: file, withExtension: "json"), let data = try? Data(contentsOf: filePath) else {
                return (404, nil)
            }
            return (status, data)
        }
    }
    
    static func set(forPath path: String, status: Int, json: String) {
        set(forPath: path) { _ in
            (status, json.data(using: .utf8))
        }
    }
    
    static let lock = NSLock()
    
}

fileprivate class MockURLProtocol: URLProtocol {
    
    enum MockProtocolError: Error {
        case failed
    }

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        defer { MockResponses.lock.unlock() }
        MockResponses.lock.lock()
        guard let url = request.url else {
            client?.urlProtocol(self, didFailWithError: MockProtocolError.failed)
            return
        }
        let path = url.path.isEmpty ? "/" : url.path
        guard let response = MockResponses.responses[path]?(request) ?? MockResponses.responses["*"]?(request) else {
            client?.urlProtocol(self, didFailWithError: MockProtocolError.failed)
            return
        }
        guard let urlResponse = HTTPURLResponse(url: url, statusCode: response.0, httpVersion: "1.0", headerFields: nil) else {
            client?.urlProtocol(self, didFailWithError: MockProtocolError.failed)
            return
        }
        client?.urlProtocol(self, didReceive: urlResponse, cacheStoragePolicy: .notAllowed)
        if let data = response.1 {
            client?.urlProtocol(self, didLoad: data)
        }
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        // nothing
    }
}

extension URLSession {
    
    static var mock: URLSession = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: configuration)
    }()
    
}

extension MockResponses {
    
    static var username: String? = "michael"
    static var bundle: Bundle = Bundle.main

    // maps request like GET /user/8922/ to get_user_8922.json and looks for a JSON file of that name in the bundle
    // if username is set will first check for get_user_8922_username.json. allows different logins to influence mocks
    static func setupDefaultJSONBundleHandler() {
        MockResponses.set(forPath: "*") { req in
            guard let tempPath = req.url?.path.replacingOccurrences(of: "/", with: "_"), let method = req.httpMethod else {
                return (500, nil)
            }
            let path = "\(method)\(tempPath)".trimmingCharacters(in: CharacterSet(["_"]))
            if let user = MockResponses.username,
               let url = MockResponses.bundle.url(forResource: "\(path)_\(user)".lowercased(), withExtension: "json"),
               let data = try? Data(contentsOf: url) {
                return (200, data)
            }
            if let url = MockResponses.bundle.url(forResource: path.lowercased(), withExtension: "json"),
               let data = try? Data(contentsOf: url) {
                return (200, data)
            }
            return (404, nil)
        }
    }
}
