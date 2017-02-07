//
//  NetworkRequest.swift
//  Climately
//
//  Created by Kevin Zeckser on 2/7/17.
//  Copyright © 2017 Kevin Zeckser. All rights reserved.
//

import Foundation

enum NetworkRequestError: Error, CustomStringConvertible {
    case invalidURL(String)
    
    var description: String {
        switch self {
        case .invalidURL(let url):
            return "The URL: \(url) was invalid"
        }
    }
}

/**
 Configurable network request layer on top of NSURLRequest.
 
 - parameter method: HTTP method call keyword (required)
 - parameter url: URL that will be queried (required)
 - parameter headers: if headers are needed, pass them in here (optional)
 */
struct NetworkRequest {
    //MARK: - HTTP Methods
    enum Method: String {
        case GET    = "GET"
        case PUT    = "PUT"
        case PATCH  = "PATCH"
        case POST   = "POST"
        case DELETE = "DELETE"
    }
    
    //MARK: - Public Properties
    let method: NetworkRequest.Method
    let url: String
    let headers: [String : String]?
    
    //MARK: - Public Functions
    func buildURLRequest() throws -> URLRequest {
        guard let url = URL(string: self.url) else { throw NetworkRequestError.invalidURL(self.url) }
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = self.method.rawValue
        guard let headers = headers else { return request as URLRequest }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        return request as URLRequest
    }
}
