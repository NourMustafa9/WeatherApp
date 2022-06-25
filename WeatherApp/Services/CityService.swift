//
//  CityService.swift
//  WeatherApp
//
//  Created by Nour_Madar on 24/06/2022.
//

import Foundation
import AFNetworking

import Foundation

protocol CityServiceProtocol {
    func getWeatherInfo(cityName : String,completion: @escaping (_ success: Bool, _ results: CityWeatherInfo?, _ error: String?) -> ())
}

class CityService: CityServiceProtocol {
    static let citySharedCervice : CityService = CityService()

    /// This function to search for City Weather Info from Api and parse Json
    ///
    /// ```
    ///
    /// ```
    ///

    /// - Parameter cityName: city To search with
    ///- Parameter completion: The callback called after retrieing and parsing.
    /// - Returns: none.

    func getWeatherInfo(cityName : String, completion: @escaping (Bool, CityWeatherInfo?, String?) -> ()) {
        var city = cityName.replacingOccurrences(of: " ", with: "%20")
        let url = Constants.domain + city + Constants.urlApiKey
        HTTPRequestService().GET(url: url) { success, data in
            if success {
                var descrip = ""
                var temp = 0.0
                var speed = 0.0
                var humidity = 0
                var icon = ""
                var countryName = ""
                if let resultNew = data as? [String:Any] {
                    print(resultNew,"resultNew")
                    if let weather = resultNew["weather"] as? NSArray{
                        print("my result",weather)
                        if let description = weather.firstObject as? [String:Any] {
                            if let des = description["description"] as? String{
                                descrip = des
                            }
                        https://openweathermap.org/img/w/03d@2x.png
                            if let iconUrl = description["icon"] as? String{
                                icon = Constants.iconUrl + iconUrl + Constants.iconExtension
                            }
                        }



                    }

                    if let mainRes = resultNew["wind"] as? [String:Any]{
                        if let windSpeed = mainRes["speed"] as? Double{
                            speed = windSpeed
                        }
                    }

                    if let mainRes = resultNew["main"] as? [String:Any]{
                        if let mainTemp = mainRes["temp"] as? Double{
                            temp = mainTemp
                        }

                        if let mainHumidity = mainRes["humidity"] as? Int{
                            humidity = mainHumidity
                        }
                    }

                    if let system = resultNew["sys"] as? [String:Any]{
                        if let country = system["country"] as? String{
                            countryName = country
                        }

                    }

                    let cityWeather = CityWeatherInfo(name: cityName + ", \(countryName)", weatherDescription: descrip, speed: speed, temp: temp, humidity: humidity, iconUrl: icon, cityName: cityName)
                    completion(true,cityWeather,"success")
                }

                //                  print(data)
                //completion(success)
            } else {
                completion(false, nil, "Error: Cities GET Request failed")
            }
        }
    }
}

