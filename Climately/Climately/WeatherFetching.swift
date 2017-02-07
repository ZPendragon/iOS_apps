//
//  WeatherFetching.swift
//  Climately
//
//  Created by Kevin Zeckser on 2/7/17.
//  Copyright © 2017 Kevin Zeckser. All rights reserved.
//

import Foundation

typealias JSONDictionary = [String: AnyObject]

final class WeatherClient {
    
    // MARK: - Properties
    
    static let apiKey = "715c8dedd9cb08be"
    static let headers = ["Accept": "application/json"]
    static let url = {
        return "http://api.wunderground.com/api/" + apiKey + "/conditions/q/"
    }
    
    /**
     Converts NSData to relevant JSON data.
     
     - parameter data: NSData returned from a network request
     - returns: an optional JSON Dictionary containing an array of weather metrics.
     */
    
    func jsonForData(_ data: Data) -> JSONDictionary? {
        var weatherData: JSONDictionary?
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as! JSONDictionary
            
            if let observationDictionary = json["current_observation"] as? JSONDictionary {
                weatherData = observationDictionary
            }
        } catch { print(error) }
        return weatherData
    }
    
}
