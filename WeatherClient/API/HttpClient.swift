//
//  HttpClient.swift
//  WeatherClient
//
//  Created by Piyush on 8/26/16.
//  Copyright © 2016 Piyush. All rights reserved.
//

import Foundation

//Wrap server response using enum
enum Response<T> {
    case Success(AnyObject)
    case Failure(AnyObject)
}

class HttpClient {
    
    typealias CompletionHandler = ((result: Response<AnyObject>) -> Void)
   
    let config = NSURLSessionConfiguration.defaultSessionConfiguration()
    
    var session: NSURLSession {
        config.requestCachePolicy = .ReloadIgnoringLocalCacheData
        config.timeoutIntervalForRequest = 5
        config.timeoutIntervalForResource = 5
        return NSURLSession(configuration: config)
    }
    
    func sendRequest(requestUrl: NSURL, completionHandler: CompletionHandler) {
        let task = session.dataTaskWithURL(requestUrl) { (data, response, error) in
            var statusCode: Int?
            if let response = response as? NSHTTPURLResponse {
                statusCode = response.statusCode
            }
            
            if let apiResponseCode = statusCode where apiResponseCode == 200 {
                completionHandler(result: Response.Success(data!))
            }
            else {
                if error != nil {
                    completionHandler(result: Response.Failure(error!.localizedDescription))
                }
                else {
                    if let errorData = data {
                        completionHandler(result: Response.Failure(errorData))
                    }
                }
            }
        }
        task.resume()
    }
}