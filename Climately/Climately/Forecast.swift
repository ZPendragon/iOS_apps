//
//  WeatherProfileCity.swift
//  Climately
//
//  Created by Kevin Zeckser on 2/6/17.
//  Copyright © 2017 Kevin Zeckser. All rights reserved.
//

import Foundation

struct Forecast {
    
    // MARK: - Properties
    
    let name:                   String
    let currentObservation:     String
    let currentTemperature:        Int
    let feelsLike:              String
    let humidity:               String?
    let precipitation:          String?
    let windDirection:          String?
    let windSpeed:              Float?
    
    init?(fromDictionary dict: [String : AnyObject]) {
        guard let name = dict["city"] as? String,
            let currentObservation = dict["weather"] as? String,
            let currentTemperature = dict["temp_f"] as? Int,
            let feelsLike = dict["feelslike_f"] as? String,
            let humidity = dict["relative_humidity"] as? String,
            let precipitation = dict["precip_today_metric"] as? String,
            let windDirection = dict["wind_dir"] as? String,
            let windSpeed = dict["wind_mph"] as? Float else {
            print(dict)
            print("Failed to init")
            return nil
        }
        
        self.name = name
        self.currentObservation = currentObservation
        self.currentTemperature = currentTemperature
        self.feelsLike = feelsLike
        self.humidity = humidity
        self.precipitation = precipitation
        self.windDirection = windDirection
        self.windSpeed = windSpeed
    }
    
}
