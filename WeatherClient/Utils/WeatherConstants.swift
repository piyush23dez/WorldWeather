//
//  WeatherConstants.swift
//  WeatherClient
//
//  Created by Piyush on 8/26/16.
//  Copyright © 2016 Piyush. All rights reserved.
//

import UIKit

typealias Coordinate = (latitude: Double,longitude: Double)

class WeatherConstants {
    
    enum NibNames {
        case WeatherView
        var nibName: String {
            switch self {
            case .WeatherView:
                 return "WeatherView"
            }
        }
    }
    
    static var screenWidth: CGFloat {
        return UIScreen.mainScreen().bounds.size.width
    }
    static var screenHeight: CGFloat {
        return UIScreen.mainScreen().bounds.size.height
    }
    
    //Network Constants
    static let weatherInfoURL = "https://api.forecast.io/forecast/%@/%f,%f"
    static let apiKey = "800d8d8dc7b5bb039531853037577094"
    
    //Error dialog messages
    static let EmptyLatitudeDialogMessage = "Please Enter Latitude"
    static let EmptyLongitudeDialogMessage = "Please Enter Longitude"
    static let EmptyLatLongDialogMessage = "Please Enter Latitude and Longitude"
}

struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.mainScreen().bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.mainScreen().bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS  = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P         = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPAD              = UIDevice.currentDevice().userInterfaceIdiom == .Pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
}