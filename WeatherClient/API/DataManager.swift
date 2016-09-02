//
//  DataManager.swift
//  WeatherClient
//
//  Created by Piyush on 8/26/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import Foundation

struct DataManager {
    
    private var weather: Weather?
    
    mutating func save(weather: Weather) {
        self.weather = weather
    }
    
    func getWeather() -> Weather {
        return weather!
    }
}