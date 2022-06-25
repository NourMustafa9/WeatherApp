//
//  CityWeatherInfo.swift
//  WeatherApp
//
//  Created by Nour_Madar on 24/06/2022.
//

import Foundation

/// This Class is for CityWeatherInfo retrieved from API
///
/// ```
///
/// ```
///

class CityWeatherInfo  {
    var name: String = ""
    var cityName: String = ""
    var weatherDescription: String = ""
    var temp: Double = 0.0
    var speed: Double = 0.0
    var humidity: Int = 0
    var iconUrl: String = ""
    init(name: String, weatherDescription: String,speed: Double,temp:Double,humidity: Int,iconUrl:String,cityName:String){
        self.name = name
        self.weatherDescription = weatherDescription
        self.speed = speed
        self.humidity = humidity
        self.temp = temp
        self.iconUrl = iconUrl
        self.cityName = cityName
    }

}
