//
//  RequestService.swift
//  CodeProject
//
//  Created by Alex Fu on 11/25/20.
//
import Foundation

class RequestService {
    func requestData(urlString: String, completion: @escaping (WeatherModel) -> Void, errorHandler: @escaping (ErrorType) -> Void) {
        guard let urlString = URL(string: urlString) else {
            errorHandler(.unknown)
            return
        }

        let request = URLRequest(url: urlString)

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                errorHandler(.unknown)
                return
                }

            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(WeatherModel.self, from: data) {
                    completion(decodedResponse)
                }  else {
                    errorHandler(.unknown)
                }
            } else {
                errorHandler(.unknown)
            }
        }.resume()
    }
}
