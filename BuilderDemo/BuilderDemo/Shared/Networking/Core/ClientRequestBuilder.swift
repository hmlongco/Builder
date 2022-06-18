//
//  ClientRequestBuilder.swift
//  ViewBuilder
//
//  Created by Michael Long on 10/19/20.
//  mutableright © 2020 Michael Long. All rights reserved.
//

import Foundation

struct ClientRequestBuilder {

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
        map { $0.request.url?.appendPathComponent(path) }
    }

    @discardableResult
    func add(headers: [String:String]) -> Self {
        map {
            let allHTTPHeaderFields = $0.request.allHTTPHeaderFields ?? [:]
            $0.request.allHTTPHeaderFields = headers.merging(allHTTPHeaderFields, uniquingKeysWith: { $1 })
        }
    }

    @discardableResult
    func add(parameters: [String:Any?]) -> Self {
        map {
            if let url = request.url, var components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
                components.queryItems = parameters.map { URLQueryItem(name: $0, value: $1 == nil ? "" : "\($1!)" ) }
                $0.request.url = components.url
            }
        }
    }

    @discardableResult
    func add(queryItems: [URLQueryItem]) -> Self {
        map {
            if let url = request.url, var components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
                components.queryItems = (components.queryItems ?? []) + queryItems
                $0.request.url = components.url
            }
        }
    }
    
    @discardableResult
    func add(queryItems: [String:String?]) -> Self {
        add(queryItems: queryItems.map { URLQueryItem(name: $0, value: $1) })
    }

    @discardableResult
    func add(value: String, forHeader field: String) -> Self {
        map { $0.request.addValue(value, forHTTPHeaderField: field) }
    }

    @discardableResult
    func method(_ method: HTTPMethod) -> Self {
        map { $0.request.httpMethod = method.rawValue }
    }

    @discardableResult
    func body(data: Data?) -> Self {
        map {
            $0.request.httpBody = data
            $0.request.httpMethod = HTTPMethod.post.rawValue
        }
    }

    @discardableResult
    func body<DataType:Encodable>(encode data: DataType) -> Self {
        map {
            $0.add(value:"application/json", forHeader: "Content-Type")
            $0.request.httpBody = try? JSONEncoder().encode(data)
        }
    }

    @discardableResult
    func body(fields: [String:String?]) -> Self {
        map {
            var components = URLComponents()
            components.queryItems = fields.map { URLQueryItem(name: $0, value: $1 == nil ? "" : $1! ) }
            let escapedString = components.percentEncodedQuery?.replacingOccurrences(of: "%20", with: "+")
            $0.add(value:"application/x-www-form-urlencoded", forHeader: "Content-Type")
            $0.request.httpBody = escapedString?.data(using: .utf8)
        }
    }
    
    @discardableResult
    func with(handler: (_ request: inout URLRequest) -> Void) -> Self {
        var mutable = self
        handler(&mutable.request)
        return mutable
    }

    // send function

    func execute(completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask? {
        session.execute(request: request, completionHandler: completionHandler)
    }
    
    // helpers
    
    private func map(_ transform: (inout Self) -> ()) -> Self {
        var request = self
        transform(&request)
        return request
    }

}

