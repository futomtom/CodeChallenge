// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let weatherModel = try? newJSONDecoder().decode(WeatherModel.self, from: jsonData)

import Foundation

struct WeatherModel: Codable {
    var main: Main
}

struct Main: Codable {
    var temp: Double
}





