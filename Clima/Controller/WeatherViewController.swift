//
//  WeatherViewController.swift
//  Clima
//
//  Created by Fredy Sanchez on 17/01/23.
//  Copyright © 2023 Alfredo Sanchez. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This will let the text field to report back to the controller
        // when certain events are triggered (focus-out, return, etc.)
        searchTextField.delegate = self
        weatherManager.delegate = self
    }
}

//MARK - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {

    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }

    // Asks the delegate whether to process the pressing of the Return button for
    // the text field.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    // Verify if there textField has an input
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if let city = textField.text, city.isEmpty {
            textField.placeholder = "Type a city!"
            return false
        } else {
            return true
        }
    }
    
    // Attempt to fetch the weather with the input from the text field.
    // Then clear the text field.
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = textField.text {
            weatherManager.fetchWeather(city: city)
        }
        textField.text = String()
    }
}

//MARK - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    
    // Handle the API response to update the UI
    func didUpdateWeather(_ weatherManager: WeatherManager, _ weather: WeatherModel) {
        DispatchQueue.main.async {
            self.conditionImageView.image = UIImage(systemName: weather.weatherConditionName)
            self.temperatureLabel.text = weather.temperatureString
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(_ error: Error) {
        print(error)
    }
}
