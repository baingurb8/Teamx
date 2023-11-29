//
//  WeatherHelper.swift
//  Teamx
//
//  Created by Gurbir Bains on 2023-11-29.
//

import Foundation
import CoreLocation

class WeatherHelper: ObservableObject {
    @Published var weatherInfo: Weather?

    func fetchDataFromAPI(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let apiString =
        "https://api.weatherapi.com/v1/current.json?key=96e243f713664eaface65000230308&q=\(latitude),\(longitude)"

        guard let apiURL = URL(string: apiString) else {
            print("Unable to create API URL")
            return
        }

        let task = URLSession.shared.dataTask(with: apiURL) { data, response, error in
            guard let jsonData = data, error == nil else {
                print("Error fetching data:", error?.localizedDescription ?? "Unknown error")
                return
            }
            do {
                let decoder = JSONDecoder()
                let weatherData = try decoder.decode(Weather.self, from: jsonData)
                DispatchQueue.main.async {
                    self.weatherInfo = weatherData
                    print("Fetched Weather Data:", weatherData)//checks if model was done correctly
                }
            } catch {
                print("Error decoding data:", error.localizedDescription)
            }
        }

        task.resume()
    }
}
