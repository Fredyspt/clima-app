//
//  WeatherData.swift
//  Clima
//
//  Created by Fredy Sanchez on 17/01/23.
//  Copyright © 2023 Alfredo Sanchez. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
    let weather: [Weather]
    let main: Main
    let name: String
}

struct Weather: Decodable {
    let id: Int
}

struct Main: Decodable {
    let temp: Double
}
