//
//  WeatherProfileCityViewModel.swift
//  Climately
//
//  Created by Kevin Zeckser on 2/6/17.
//  Copyright © 2017 Kevin Zeckser. All rights reserved.
//

import Foundation

struct WeatherProfileCityViewModel {
    var weatherProfile: WeatherProfileCity
    
    var name: String {
        return weatherProfile.name
    }
    var currentObservation: String {
        return weatherProfile.currentObservation
    }
    var currentTemperature: String {
        return String(weatherProfile.currentTemperature) + "º"
    }
    var feelsLike: String {
        return weatherProfile.feelsLike + "º"
    }
    var humidity: String? {
        return weatherProfile.humidity
    }
    var precipitation: String? {
        return weatherProfile.precipitation
    }
    var windDirection: String? {
        return weatherProfile.windDirection
    }
    var windSpeed: String {
        return String(describing: weatherProfile.windSpeed)
    }
    
    init(weatherProfileCity: WeatherProfileCity) {
        self.weatherProfile = weatherProfileCity
    }
    
}
