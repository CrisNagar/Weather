//
//  WeatherResponseDataModel.swift
//  TheWeatherAPP
//
//  Created by CrisNagar on 21/1/22.
//

import Foundation

struct WeatherResponseDataModel: Decodable {
    let city: String
    let weather: [WeatherDataModel]
    let temperature: TemperatureDataModel
    let sun: SunModel
    let timezone: Double
    
    enum CodingKeys: String, CodingKey {
        case city = "name"
        case weather
        case temperature = "main"
        case sun = "sys"
        case timezone
    }
}

struct WeatherDataModel: Decodable {
    let main: String
    let description: String
    let iconURLString: String
    
    enum CodingKeys: String, CodingKey {
        case main
        case description
        case iconURLString = "icon"
    }
}

struct TemperatureDataModel: Decodable {
    let currentTemperature: Double
    let minTemperature: Double
    let maxTemperature: Double
    let humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case currentTemperature = "temp"
        case minTemperature = "temp_min"
        case maxTemperature  = "temp_max"
        case humidity
    }
}

struct SunModel: Decodable {
    let sunrise: Date
    let sunset: Date
}


// RESPONSE EXAMPLE
/*{
    "coord": {
        "lon": 2.159,
        "lat": 41.3888
    },
    "weather": [
        {
            "id": 802,
            "main": "Clouds",
            "description": "nubes dispersas",
            "icon": "03d"
        }
    ],
    "base": "stations",
    "main": {
        "temp": 9.1,
        "feels_like": 7.95,
        "temp_min": 7.53,
        "temp_max": 11.53,
        "pressure": 1025,
        "humidity": 64
    },
    "visibility": 10000,
    "wind": {
        "speed": 2.24,
        "deg": 284
    },
    "clouds": {
        "all": 40
    },
    "dt": 1642782602,
    "sys": {
        "type": 2,
        "id": 18549,
        "country": "ES",
        "sunrise": 1642749118,
        "sunset": 1642783976
    },
    "timezone": 3600,
    "id": 3128760,
    "name": "Barcelona",
    "cod": 200
}*/
