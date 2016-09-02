//
//  Weather.swift
//  WeatherClient
//
//  Created by Piyush on 8/26/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import Foundation


struct Weather {
    
    var time: String?
    var temperature: Float?
    var weatherSummary: String?
    var precipProbability: Float?
    
    init() {}
}

extension Weather {
        
    func getFormattedTime(time: Double, timeZone: String) -> String {
        
        //Convert NSTimeInterval to NSDate
        let date = NSDate(timeIntervalSinceReferenceDate: time)
        
        //Get Date Formatter
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.timeZone = NSTimeZone(name: timeZone)
        
        //Get formated date from NSDate as string
        let formattedDate = dateFormatter.stringFromDate(date)
        return formattedDate
    }
    
    
    var temperatureString: String {
        return "\(Int(round(temperature!)))°"
    }
    
    var precipProbabilityString: String {
        return "\(precipProbability!)%"
    }
}