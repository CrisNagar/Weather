//
//  WeatherModel.swift
//  Weather
//
//  Created by Carles on 22/1/22.
//

import Foundation

struct WeatherModel {
    let city: String
    let country: String
    let weather: String
    let description: String
    let iconURL: URL?
    let currentTemperature: String
    let minTemperature: String
    let maxTemperature: String
    let humidity: String
    let sunset: Date
    let sunrise: Date
    
    static let empty: WeatherModel = .init(city: " ",
                                           country: " ",
                                           weather: " ",
                                           description: " ",
                                           iconURL: nil,
                                           currentTemperature: " ",
                                           minTemperature: " ",
                                           maxTemperature: " ",
                                           humidity: " ",
                                           sunset: .now,
                                           sunrise: .now)
    
    static func getDateFormatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}
