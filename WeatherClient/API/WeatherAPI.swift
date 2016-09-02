//
//  WeatherAPI.swift
//  WeatherClient
//
//  Created by Piyush on 8/26/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import Foundation

class WeatherAPI {
    
    //Singleton instance
    static let sharedInstance = WeatherAPI()
    
    private var httpClient: HttpClient?
    private var dataManager: DataManager?
    var WeatherInfoFetched: ((Weather?) -> Void)!
    var WeatherFetchError: ((String?) -> Void)!

    private init() {
        httpClient = HttpClient()
        dataManager = DataManager()
    }
    
    //Get weather data from data manager
    func getWeatherInfo(coordinate: Coordinate) {
        
        getWeatherDataFromServer(coordinate) { [weak self] success , error in
            if success {
                //delegate to respective controller once data is fetched
                self?.WeatherInfoFetched(self?.dataManager?.getWeather())
            }
            else {
                if let error = error {
                    //delegate to respective controller if data fetch fails
                    self?.WeatherFetchError(error as? String)
                }
            }
        }
    }
}

private extension WeatherAPI {
    
    //Send request to server to get weather details
    func getWeatherDataFromServer(coordinate: Coordinate, Completion: ((success: Bool,error: AnyObject?) -> Void)) {
       
        let url =  String(format: WeatherConstants.weatherInfoURL, WeatherConstants.apiKey, coordinate.latitude, coordinate.longitude)
        let serviceURL = NSURL(string: url)
        
        httpClient?.sendRequest(serviceURL!, completionHandler: { [weak self] (result: Response<AnyObject>) in
            
            switch result {
            case .Success(let data):
                let weather = self?.getParsedWeatherInfo(data as! NSData)
                
                //save parsed data in data manager
                self?.dataManager?.save(weather!)
               
                Completion(success: true, error: nil)
            case .Failure(let errorValue):
                if let errorString  = errorValue as? String {
                    Completion(success: false, error: errorString)
                }
                else {
                    let errorJson = JSON(data: errorValue as! NSData)
                    let errorDesc = errorJson["error"].string
                    Completion(success: false, error: errorDesc)
                }
            }
        })
    }
    
    //Returns parsed weather object
    func getParsedWeatherInfo(data: NSData) -> Weather {
        
        var weather = Weather()

        //JSON is a library for parsing server data
        let json = JSON(data: data)
        
        if let time = json["currently"]["time"].double, let timeZone = json["timezone"].string {
            weather.time = weather.getFormattedTime(time, timeZone: timeZone)
        }
        
        if let temp = json["currently"]["temperature"].float {
            weather.temperature = temp
        }
        
        if let summary = json["currently"]["summary"].string {
            weather.weatherSummary = summary
        }
        
        if let precipProbability = json["currently"]["precipProbability"].float {
            weather.precipProbability = precipProbability
        }
        return weather
    }
}
