//
//  Network.swift
//  Climately
//
//  Created by Kevin Zeckser on 2/7/17.
//  Copyright © 2017 Kevin Zeckser. All rights reserved.
//

import Foundation

enum NetworkError: Error, CustomStringConvertible {
    case unknown
    case invalidResponse
    
    var description: String {
        switch self {
        case .unknown:
            return "An unknown error has occured."
        case .invalidResponse:
            return "Received an invalid response."
        }
    }
}

protocol NetworkCancelable {
    func cancel()
}

extension URLSessionDataTask: NetworkCancelable { }

protocol Network {
    func makeRequestForData(_ request: NetworkRequest,
                            success: @escaping (Data) -> Void,
                            failure: @escaping (Error) -> Void) -> NetworkCancelable?
    func makeRequestForJSON(_ request: NetworkRequest,
                            success: @escaping ([String : AnyObject]) -> Void,
                            failure: @escaping (Error) -> Void) -> NetworkCancelable?
    }
