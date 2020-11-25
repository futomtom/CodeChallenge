//
//  Constant.swift
//  CodeProject
//
//  Created by Alex Fu on 11/25/20.
//

import Foundation

enum Fb {
    static var authURL: URL {
        return try! URL(string: "https://" + Configuration.value(for: "FBbaseURL"))!
    }

    static var AppID: String {
        return try! Configuration.value(for: "FaceBookAppID")
    }
}

enum OpenWeather {
    static var basePath: String {
        let base: String = try! Configuration.value(for: "WeatherBaseURL")
        return "https://" + base
    }

    static var APIKEY: String {
        return try! Configuration.value(for: "WeatherAPI_KEY")
    }
}
