//
//  MockURLProtocol.swift
//  Builder
//
//  Created by Michael Long on 9/30/21.
//

import Foundation


class MockURLProtocol: URLProtocol {
    
    enum MockProtocolMode {
        case off
        case allowMatchOnly
        case allowWildcardOnly
        case allowAny
    }
    
    enum MockProtocolError: Error {
        case failed
    }

    static var responses: [String:(_ request: URLRequest) throws -> (Int,Data?)] = [:]
    static var mode: MockProtocolMode = .allowAny
    static var delay: Double?
    static let lock = NSLock()

    override class func canInit(with request: URLRequest) -> Bool {
        return handler(for: request.url) != nil
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    class func handler(for url: URL?) -> ((_ request: URLRequest) throws -> (Int,Data?))? {
        guard let path = url?.path else {
            return nil
        }
        switch mode {
        case .off:
            return nil
        case .allowMatchOnly:
            return Self.responses[path.isEmpty ? "/" : path]
        case .allowWildcardOnly:
            return Self.responses["*"]
        case .allowAny:
            return Self.responses[path.isEmpty ? "/" : path] ?? Self.responses["*"]
        }
    }
    
    override func startLoading() {
        if let delay = Self.delay {
            DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + delay) {
                self.loadFromMockURLProtocol()
            }
        } else {
            self.loadFromMockURLProtocol()
        }
    }
    
    func loadFromMockURLProtocol() {
        defer { Self.lock.unlock() }
        Self.lock.lock()
        do {
            guard let url = request.url,
                  let response = try Self.handler(for: url)?(request),
                  let urlResponse = HTTPURLResponse(url: url, statusCode: response.0, httpVersion: "1.0", headerFields: nil) else {
                client?.urlProtocol(self, didFailWithError: MockProtocolError.failed)
                return
            }
            client?.urlProtocol(self, didReceive: urlResponse, cacheStoragePolicy: .notAllowed)
            if let data = response.1 {
                client?.urlProtocol(self, didLoad: data)
            }
            client?.urlProtocolDidFinishLoading(self)
        }
        catch {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }
    }
    
    override func stopLoading() {
        // nothing
    }
}

extension MockURLProtocol {
    
    static func set(forPath path: String, response: @escaping (_ request: URLRequest) throws -> (Int,Data?)) {
        defer { lock.unlock() }
        lock.lock()
        responses[path] = response
    }
    
    static func set(forPath path: String, status: Int, data: Data? = nil) {
        set(forPath: path) { _ in
            (status, data)
        }
    }
    
    static func set(forPath path: String, error: APIError) {
        set(forPath: path) { _ in
            throw error
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

}

extension MockURLProtocol {
    
    static var username: String?
    static var bundle: Bundle = Bundle.main

    // maps request like GET /user/8922/ to get_user_8922.json and looks for a JSON file of that name in the bundle
    // if username is set will first check for get_user_8922_username.json. allows different logins to influence mocks
    static func setupDefaultJSONBundleHandler() {
        Self.set(forPath: "*") { req in
            guard let tempPath = req.url?.path.replacingOccurrences(of: "/", with: "_"), let method = req.httpMethod else {
                return (500, nil)
            }
            let path = "\(method)\(tempPath)".trimmingCharacters(in: CharacterSet(["_"]))
            if let user = Self.username,
               let url = Self.bundle.url(forResource: "\(path)_\(user)".lowercased(), withExtension: "json"),
               let data = try? Data(contentsOf: url) {
                return (200, data)
            }
            if let url = Self.bundle.url(forResource: path.lowercased(), withExtension: "json"),
               let data = try? Data(contentsOf: url) {
                return (200, data)
            }
            return (404, nil)
        }
    }
}

extension URLSession {
    
    static var mock: URLSession = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: configuration)
    }()
    
}
