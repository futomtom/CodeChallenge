//
//  RequestService.swift
//  CodeProject
//
//  Created by Alex Fu on 11/25/20.
//
import Foundation

class RequestService {
    func requestData(url: URL, completion: @escaping (WeatherModel) -> Void, errorHandler: @escaping (ErrorType) -> Void) {
        let request = URLRequest(url: url)

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard  let data = data, let decodedResponse = try? JSONDecoder().decode(WeatherModel.self, from: data), decodedResponse.main != nil else {
                errorHandler(.unknown)
                return
            }
            completion(decodedResponse)
        }.resume()
    }
}
