// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let weatherModel = try? newJSONDecoder().decode(WeatherModel.self, from: jsonData)

import Foundation

// MARK: - Post

struct WeatherModel: Codable {
   // let weather: [Weather]
   // let main: Main
    let name: String
}

// MARK: - Main

struct Main: Codable {
    let temp: Double
}

// MARK: - Weather

struct Weather: Codable {
    let id: Int
    let main, weatherDescription, icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}
