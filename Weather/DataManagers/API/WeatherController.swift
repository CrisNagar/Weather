//
//  WeatherController.swift
//  Weather
//
//  Created by Carles on 22/1/22.
//

import Foundation
import UIKit

final class WeatherController{
    
    var info: WeatherModel = .empty
    private let weatherModelMapper: WeatherModelMapper
    
    init(mapper: WeatherModelMapper = WeatherModelMapper()) {
        self.weatherModelMapper = mapper
    }
    
    func getWeather(city: String) async {
        if city.isEmpty {
            self.info = .empty
        } else {
            if let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=71c3e78149e90edcb26b5c8bf57708fa&units=metric&lang=\(LocalizableUtil.language.rawValue)") {
                do {
                    async let (data, _) = try await URLSession.shared.data(from: url)
                    guard let dataModel = try? await JSONDecoder().decode(WeatherResponseDataModel.self, from: data)
                    else {
                        return print("error en getWeather")
                    }
                    
                    DispatchQueue.main.async {
                        self.info = self.weatherModelMapper.mapData(dataModel: dataModel)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
    }
}
