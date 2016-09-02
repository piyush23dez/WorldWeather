//
//  WeatherViewController.swift
//  WeatherClient
//
//  Created by Piyush on 8/26/16.
//  Copyright © 2016 Piyush. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    let weatherView = WeatherView(frame: CGRect(x: 0, y: 0, width: WeatherConstants.screenWidth, height:  WeatherConstants.screenHeight))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherView.delegate = self
        view.addSubview(weatherView)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //Update ui elemens
        weatherView.handleDifferentScreenSizeSpacing()
    }
}

extension WeatherViewController: WeatherInfoDelegate {
    
    func getWeatherInfo(coordinate: Coordinate) {
       
        addOverlay()
        
        //Fetch weather data through a weather api
        WeatherAPI.sharedInstance.getWeatherInfo(coordinate)
        
        //Callback for data fetch
        WeatherAPI.sharedInstance.WeatherInfoFetched = { [weak self] (weather: Weather?) in
            self?.updateWeather(weather!)
        }
        
        //Callback for data fetch error
        WeatherAPI.sharedInstance.WeatherFetchError = { [weak self] error in
            self?.showErrorMessage(error!)
        }
    }

    func showInputError(message: String) {
        showAlert(message)
    }
}

extension WeatherViewController {
    
    func addOverlay() {
        weatherView.userInteractionEnabled = false
        
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .Alert)
        alert.view.tintColor = UIColor.blackColor()

        let loadingIndicator = UIActivityIndicatorView(frame: CGRectMake(10, 5, 50, 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = .Gray
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            loadingIndicator.startAnimating()
            alert.view.addSubview(loadingIndicator)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
    func showErrorMessage(message: String) {
        dismissViewControllerAnimated(true) { () -> Void in
            dispatch_async(dispatch_get_main_queue()) { [weak self] () -> Void in
                self?.showAlert(message)
                self?.weatherView.userInteractionEnabled = true
            }
        }
    }
    
    func showAlert(message: String) {
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

    func updateWeather(weather: Weather) {
        dismissViewControllerAnimated(true) { () -> Void in
            dispatch_async(dispatch_get_main_queue()) { [weak self] () -> Void in
                self?.weatherView.weather = weather
                self?.weatherView.showWeather()
                self?.weatherView.userInteractionEnabled = true
            }
        }
    }
}
