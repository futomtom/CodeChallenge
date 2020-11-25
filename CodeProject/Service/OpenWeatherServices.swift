//
//  OpenWeatherServices.swift
//  CodeProject
//
//  Created by Alex Fu on 11/25/20.
//
import Foundation
import UIKit

class OpenWeatherServices: RequestService {
    public enum OpenWeatherType {
        case zipcode(zip: String)
        // case city(name: String)  //expandable

        internal func endpoint(search: OpenWeatherType) -> String {
            var urlString = OpenWeather.basePath + "weather?"

            switch search {
            case let .zipcode(zip):
                urlString.append("zip=\(zip),us")
            }
            urlString.append("&units=imperial&appid=\(OpenWeather.APIKEY)")
            return urlString
        }
    }

    func weather(type: OpenWeatherType, completion: @escaping (WeatherModel) -> Void, errorHandler: @escaping (ErrorType) -> Void) {
        requestData(urlString: type.endpoint(search: type), completion: { data in
            completion(data)
        }, errorHandler: { error in
            errorHandler(error)
        })
    }
}
