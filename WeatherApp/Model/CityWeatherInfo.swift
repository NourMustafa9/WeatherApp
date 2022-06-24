//
//  CityWeatherInfo.swift
//  WeatherApp
//
//  Created by Nour_Madar on 24/06/2022.
//

import Foundation
class CityWeatherInfo  {
    var name: String = ""
    var weatherDescription: String = ""
    var temp: Double = 0.0
    var speed: Double = 0.0
    var humidity: Int = 0
    var iconUrl: String = ""
    init(name: String, weatherDescription: String,speed: Double,temp:Double,humidity: Int,iconUrl:String){
        self.name = name
        self.weatherDescription = weatherDescription
        self.speed = speed
        self.humidity = humidity
        self.temp = temp
        self.iconUrl = iconUrl

    }

}