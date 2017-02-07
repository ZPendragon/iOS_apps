//
//  NetworkProvider.swift
//  Climately
//
//  Created by Kevin Zeckser on 2/7/17.
//  Copyright © 2017 Kevin Zeckser. All rights reserved.
//

import Foundation

class NetworkProvider: Network {
    //MARK: - Private
    let session: URLSession
    typealias JSONDictionary = [String : AnyObject]
    /* Podcast data is within XMLDictionary.0, Episode data is within XMLDictionary.1 */
    typealias XMLDictionary = ([String : AnyObject], [[String : AnyObject]])
    
    //MARK: - Lifecycle
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    //MARK: - Public
    /**
     Executes a request to provided URL and returns a raw NSData object
     
     - parameter request: Configured NetworkRequest object
     - parameter success: Returns the raw data received from request
     - parameter failure: If any errors are detected, this will handle them
     
     - returns: Cancelable request
     */
    func makeRequestForData(_ request: NetworkRequest, success: @escaping (Data) -> Void, failure: @escaping (Error) -> Void) -> NetworkCancelable? {
        do {
            let request = try request.buildURLRequest()
            let task = self.session.dataTask(with: request, completionHandler: { (data, _, error) in
                guard let data = data else {
                    DispatchQueue.main.async {
                        failure(error ?? NetworkError.unknown)
                    }
                    return
                }
                DispatchQueue.main.async {
                    success(data)
                }
            })
            task.resume()
            return task
            
        } catch let error {
            failure(error)
            return nil
        }
    }
    
    /**
     Executes a request to provided URL and returns a parsed JSON dictionary
     
     - parameter request: Configured NetworkRequest object
     - parameter success: Provides a parsed JSON dictionary ready for use
     - parameter failure: If any errors are detected, this will handle them
     
     - returns: Cancelable request
     */
    func makeRequestForJSON(_ request: NetworkRequest, success: @escaping (JSONDictionary) -> Void, failure: @escaping (Error) -> Void) -> NetworkCancelable? {
        do {
            let request = try request.buildURLRequest()
            let task = self.session.dataTask(with: request, completionHandler: { (data, _, error) in
                guard let data = data else {
                    DispatchQueue.main.async {
                        failure(error ?? NetworkError.unknown)
                    }
                    return
                }
                guard let jsonOptional = try? JSONSerialization.jsonObject(with: data, options: []),
                    let json = jsonOptional as? [String : AnyObject]
                    else {
                        DispatchQueue.main.async {
                            failure(NetworkError.invalidResponse)
                        }
                        return
                }
                DispatchQueue.main.async {
                    success(json)
                }
            })
            task.resume()
            return task
            
        } catch let error {
            failure(error)
            return nil
        }
    }
}
