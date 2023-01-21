//
//  WeatherData.swift
//  Clima
//
//  Created by Fredy Sanchez on 17/01/23.
//  Copyright © 2023 Alfredo Sanchez. All rights reserved.
//

import Foundation

// Mirror's OpenWeatherMap API JSON response.
struct WeatherData: Codable {
    let weather: [Weather]
    let main: Main
    let name: String
}

struct Weather: Codable {
    let id: Int
}

struct Main: Codable {
    let temp: Double
}
