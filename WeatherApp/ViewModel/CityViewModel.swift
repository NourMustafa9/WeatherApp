//
//  CityViewModel.swift
//  WeatherApp
//
//  Created by Nour_Madar on 24/06/2022.
//

import Foundation
import CoreData
import UIKit


class CityViewModel: NSObject {
    private var cityService: CityServiceProtocol

    var reloadTableView: (() -> Void)?

    var cities = [NSManagedObject]()

    var citiesCellViewModels = [CitiesCellViewModel]() {
        didSet {
            reloadTableView?()
        }
    }

    init(cityService: CityServiceProtocol = CityService()) {
        self.cityService = cityService
    }

    func retrieveCitiesWeatherInfo(){

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "WeatherInfo")

        do {
            var ccities = try managedContext.fetch(fetchRequest)
            print(ccities)
            for i in ccities{
                print(i.value(forKey: "humidity"))
                print(i.value(forKey: "speed"))
                print(i.value(forKey: "temp"))
                print(i.value(forKey: "humidity"))
            }
        } catch {
            print(error)

        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    func retrieveCities(){

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "City")

        do {
            cities = try managedContext.fetch(fetchRequest)
            let c  = self.convertToDicArray(moArray: cities)
            do {
                let json = try JSONSerialization.data(withJSONObject: c)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodedCities = try decoder.decode([CityName].self, from: json)
                var vms = [CitiesCellViewModel]()
                for city in decodedCities {
                    vms.append(createCellModel(city: city))
                }
                self.citiesCellViewModels = vms
                self.reloadTableView?()
            } catch {
                print(error)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    func convertToDicArray(moArray: [NSManagedObject]) -> [[String: Any]] {
        var jsonArray: [[String: Any]] = []
        for item in moArray {
            var dict: [String: Any] = [:]
            for attribute in item.entity.attributesByName {
                //check if value is present, then add key to dictionary so as to avoid the nil value crash
                if let value = item.value(forKey: attribute.key) {
                    dict[attribute.key] = value
                }
            }
            jsonArray.append(dict)
        }
        return jsonArray
    }
    func createCellModel(city: CityName) -> CitiesCellViewModel {

        let name = city.name

        return CitiesCellViewModel(name: name)
    }
    func getCellViewModel(at indexPath: IndexPath) -> CitiesCellViewModel {
        return self.citiesCellViewModels[indexPath.row]
    }
    func save(name: String,completion: @escaping (Bool) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "City", in: managedContext)!
        let city = NSManagedObject(entity: entity, insertInto: managedContext)
        city.setValue(name, forKeyPath: "name")
        //        city.seto
        do {
            try managedContext.save()
            cities.append(city)
            self.reloadTableView?()
            completion(true)

        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }


    func saveWeatherInfo(weatherInfo : CityWeatherInfo,completion: @escaping (Bool,NSManagedObject) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "WeatherInfo", in: managedContext)!
        let city = NSManagedObject(entity: entity, insertInto: managedContext)
        city.setValuesForKeys(["name" : weatherInfo.name, "humidity" : weatherInfo.humidity , "speed" : weatherInfo.speed, "temp" : weatherInfo.temp , "weatherDescription" : weatherInfo.weatherDescription, "iconUrl" : weatherInfo.iconUrl,"requestTime" : Date()])
        //        city.seto

        do {
            try managedContext.save()

            completion(true,city)

        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    func getWeatherInfo(cityName : String,completion: @escaping (Bool,NSManagedObject) -> Void) {
        print("getWeatherInfogetWeatherInfo")
        CityService.citySharedCervice.getWeatherInfo(cityName: cityName) { sucees, weatherInfo, error in
            //
            if let cityWeatherInfo = weatherInfo{
                self.saveWeatherInfo(weatherInfo: cityWeatherInfo, completion: {succes,weatherInfo in
                    completion(true,weatherInfo)

                })
            }

        }
    }
}
