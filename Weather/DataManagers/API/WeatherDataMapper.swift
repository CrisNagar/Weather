//
//  WeatherDataMapper.swift
//  Weather
//
//  Created by Carles on 22/1/22.
//

import Foundation

struct WeatherModelMapper {
    func mapData(dataModel: WeatherResponseDataModel) -> WeatherModel {
        guard let weather = dataModel.weather.first else {
            return .empty
        }
        
        let temperature = dataModel.temperature
        
        let sunsetWithTimeZone = dataModel.sun.sunset.addingTimeInterval(dataModel.timezone - Double(TimeZone.current.secondsFromGMT()))
        let sunriseWithTimeZone = dataModel.sun.sunrise.addingTimeInterval(dataModel.timezone - Double(TimeZone.current.secondsFromGMT()))
        
        return WeatherModel(city: dataModel.city,
                            weather: weather.main,
                            description: "\(weather.description)",
                            iconURL: URL(string: "http://openweathermap.org/img/wn/\(weather.iconURLString)@2x.png"),
                            currentTemperature: "\(Int(temperature.currentTemperature))º",
                            minTemperature: "\(Int(temperature.minTemperature))º",
                            maxTemperature: "\(Int(temperature.maxTemperature))º",
                            humidity: "\(temperature.humidity)",
                            sunset: sunsetWithTimeZone,
                            sunrise: sunriseWithTimeZone)
    }
}
