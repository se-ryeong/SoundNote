//
//  WeatherService.swift
//  RecordApp
//
//  Created by se-ryeong on 1/12/24.
//

import UIKit
import WeatherKit
import CoreLocation

class WeatherDataHelper {
    static let shared = WeatherDataHelper()
    
    private let service = WeatherService.shared
    
    private init() { }

    func updateCurrentWeather(userLocation: CLLocation) async throws -> CurrentWeather {
        let weather = try await self.service.weather(for: userLocation, including: .current)
        return weather
    }
}
