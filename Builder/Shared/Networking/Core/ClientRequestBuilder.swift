//
//  ClientRequestBuilder.swift
//  ViewBuilder
//
//  Created by Michael Long on 10/19/20.
//  Copyright © 2020 Michael Long. All rights reserved.
//

import Foundation

class ClientRequestBuilder {

    enum HTTPMethod: String {
        case create
        case get
        case post
        case put
        case delete
    }

    let session: ClientSessionManager
    var request: URLRequest!
    
    // lifecycle

    init(_ session: ClientSessionManager, forURL url: URL? = nil) {
        self.session = session
        self.request = session.request(forURL: url)
    }

    // build functions

    @discardableResult
    func add(path: String) -> Self {
        request.url?.appendPathComponent(path)
        return self
    }

    @discardableResult
    func add(headers: [String:String?]) -> Self {
        headers
            .filter({ $0.value != nil})
            .forEach { request.addValue($0.value!, forHTTPHeaderField: $0.key) }
        return self
    }

    @discardableResult
    func add(parameters: [String:Any?]) -> Self {
        if let url = request.url, var components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            components.queryItems = parameters.map { URLQueryItem(name: $0, value: $1 == nil ? "" : "\($1!)" ) }
            request.url = components.url
        }
        return self
    }

    @discardableResult
    func add(queryItems: [URLQueryItem]) -> Self {
        if let url = request.url, var components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            components.queryItems = (components.queryItems ?? []) + queryItems
            request.url = components.url
        }
        return self
    }

    @discardableResult
    func add(value: String, forHeader field: String) -> Self {
        request.addValue(value, forHTTPHeaderField: field)
        return self
    }

    @discardableResult
    func method(_ method: HTTPMethod) -> Self {
        request.httpMethod = method.rawValue
        return self
    }

    @discardableResult
    func body(data: Data?) -> Self {
        request.httpBody = data
        request.httpMethod = HTTPMethod.post.rawValue
        return self
    }

    @discardableResult
    func body<DataType:Encodable>(encode data: DataType) -> Self {
        self.add(value:"application/json", forHeader: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(data)
        return self
    }

    @discardableResult
    func body(fields: [String:String?]) -> Self {
        self.add(value:"application/x-www-form-urlencoded", forHeader: "Content-Type")
        var components = URLComponents()
        components.queryItems = fields.map { URLQueryItem(name: $0, value: $1 == nil ? "" : $1! ) }
        let escapedString = components.percentEncodedQuery?.replacingOccurrences(of: "%20", with: "+")
        request.httpBody = escapedString?.data(using: .utf8)
        return self
    }
    
    @discardableResult
    func with(handler: (_ request: inout URLRequest) -> Void) -> Self {
        handler(&request)
        return self
    }

    // send function

    func execute(completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        session.execute(request: request, completionHandler: completionHandler)
    }

}

