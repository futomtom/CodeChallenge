//
//  OpenWeatherServices.swift
//  CodeProject
//
//  Created by Alex Fu on 11/25/20.
//
import Foundation
import UIKit

class OpenWeatherServices {
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

    static func weather<T: Decodable>(type: OpenWeatherType, completion: @escaping (Result<T, ErrorType>) -> Void) {
        guard let url = URL(string: type.endpoint(search: type)) else {
            completion(.failure(.searchFail)) //endpoint fail, should not happen
            return 
        }

        let request = URLRequest(url: url)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let weather = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(weather))
                } catch {
                    completion(.failure(.cityNotFound))
                }
            } else {
                completion(.failure(.nodata))
            }
        }.resume()
    }
}
