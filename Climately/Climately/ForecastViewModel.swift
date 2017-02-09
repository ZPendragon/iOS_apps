//
//  ForecastViewModel.swift
//  Climately
//
//  Created by Kevin Zeckser on 2/6/17.
//  Copyright © 2017 Kevin Zeckser. All rights reserved.
//

import Foundation

struct ForecastViewModel {
    var forecast: Forecast
    
    var name: String {
        return forecast.name
    }
    var currentObservation: String {
        return forecast.currentObservation
    }
    var currentTemperature: String {
        return String(forecast.currentTemperature) + "º"
    }
    var feelsLike: String {
        return forecast.feelsLike + "º"
    }
    var humidity: String? {
        return forecast.humidity
    }
    var precipitation: String? {
        return forecast.precipitation
    }
    var windDirection: String? {
        return forecast.windDirection
    }
    var windSpeed: String {
        return String(describing: forecast.windSpeed)
    }
    
    init(forecast: Forecast) {
        self.forecast = forecast
    }
    
}
