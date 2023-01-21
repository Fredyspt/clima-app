//
//  WeatherManager.swift
//  Clima
//
//  Created by Fredy Sanchez on 17/01/23.
//  Copyright © 2023 Alfredo Sanchez. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, _ weather: WeatherModel)
    func didFailWithError(_ error: Error)
}

// WeatherManager responsibility is to perform API calls, handle API response by parsing JSON into a Swift
// object, and if a delegate is set, it will inform to the delegate whenever the API responded successfully
// or failed.
struct WeatherManager {
    private var apiKey: String {
        var apiPlistDict: [String: Any]?
        guard let plistPath = Bundle.main.url(forResource: "OpenWeatherMap-Info", withExtension: "plist") else {
            print("Could find OpenWeatherMap-Info.plist file!")
            return String()
        }
        
        do {
            let apiPlistData = try Data(contentsOf: plistPath)
            if let dict = try PropertyListSerialization.propertyList(from: apiPlistData, options: [], format: nil) as? [String: Any] {
                apiPlistDict = dict
            }
        } catch {
            print(error)
        }
        
        return apiPlistDict?["API_KEY"] as? String ?? String()
    }
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?units=metric"
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(_ city: String) {
        let apiCallUrl = "\(weatherURL)&q=\(city)&appid=\(apiKey)"
        performRequest(with: apiCallUrl)
    }
    
    func fetchWeather(_ lat: Double, _ lon: Double) {
        let apiCallUrl = "\(weatherURL)&lat=\(lat)&lon=\(lon)&appid=\(apiKey)"
        performRequest(with: apiCallUrl)
    }
    
    func performRequest(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                self.delegate?.didFailWithError(error)
                return
            }
            
            guard let weatherDataJSON = data else { return }
            if let weather = self.parseJSON(weatherDataJSON) {
                self.delegate?.didUpdateWeather(self, weather)
            }
        }
        
        task.resume()
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let weatherId = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            return WeatherModel(weatherId: weatherId, cityName: name, temperature: temp)
        } catch {
            delegate?.didFailWithError(error)
            return nil
        }
    }
}
