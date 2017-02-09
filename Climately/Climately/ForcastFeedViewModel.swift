//
//  ForecastFeedViewModel.swift
//  Climately
//
//  Created by Kevin Zeckser on 2/7/17.
//  Copyright © 2017 Kevin Zeckser. All rights reserved.
//

import Foundation
typealias cityState = (String, String)

final class ForecastFeedViewModel {
    
    // MARK: - Properties
    fileprivate let defaults = UserDefaults.standard
    fileprivate var forecast: Forecast?
    
    
    fileprivate func fetchWeather(_ query: cityState, completion: @escaping (Forecast)->Void) {
        let weatherClient = WeatherClient()
        let url = formatURLWithQuery(query, url: WeatherClient.url())
        let networkProvider = NetworkProvider()
        let request = NetworkRequest(method: .GET, url: url, headers: WeatherClient.headers)
        
        networkProvider.makeRequestForData(request, success: { (data) in
            if let json = weatherClient.jsonForData(data) {
                let weatherProfile = Forecast(fromDictionary: json)
                completion(weatherProfile!)
            }
        }) {(error) in
            print("error: \(error)")
        }
    }
    
    fileprivate func formatURLWithQuery(_ query: cityState, url: String) -> String {
        let city = query.0.replacingOccurrences(of: " ", with: "_")
        let state = query.1
        let formattedQuery = url + state + "/" + city + ".json"
        
        return formattedQuery
    }
    
    // MARK: - Network Request
    
    func requestForNetworkData(_ query: cityState, _ completion: @escaping ()-> Void) {
        fetchWeather(query) { (forecast) in
            self.forecast = forecast
            completion()
        }
    }
    
}
