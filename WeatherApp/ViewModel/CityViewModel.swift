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
    var citiesRecordsCellViewModels = [CitiesRecordViewModel]() {
        didSet {
            reloadTableView?()
        }
    }
    init(cityService: CityServiceProtocol = CityService()) {
        self.cityService = cityService
    }
    /// This function returns CitiesWeatherInfo
    ///
    /// ```
    ///
    /// ```
    ///
    /// - Returns: no return.
    func retrieveCitiesWeatherInfo(){

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "WeatherInfo")

        do {
            let ccities = try managedContext.fetch(fetchRequest)
        } catch {
            print(error)

        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    /// This function returns cities names if found in database and  populate the citiesCellViewModels .
    ///
    /// ```
    ///
    /// ```
    ///
    /// - Returns: no return.

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



    /// This function used to convert NSManaged objects of core data to Dictionary for easy use
    ///
    /// ```
    ///
    /// ```
    ///
    ///
    /// - Parameter moArray: array to be converted.
    /// - Returns: an array of Dictionary.

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

    /// This function used to create city view model used in CitiesTableViewController
    ///
    ///
    ///
    /// - Parameter city cityName
    /// - Returns: CitiesCellViewModel  used in CitiesTableViewController
    func createCellModel(city: CityName) -> CitiesCellViewModel {

        let name = city.name

        return CitiesCellViewModel(name: name)
    }

    /// This function used to get Cell View Model  used in CitiesTableViewController using indexpath
    ///
    ///
    ///
    /// - Parameter indexPath IndexPath
    /// - Returns: Cell View Model  used in CitiesTableViewController
    func getCellViewModel(at indexPath: IndexPath) -> CitiesCellViewModel {
        return self.citiesCellViewModels[indexPath.row]
    }

    /// This function used to get specific Cell View Model  used in CitiesTableViewController using row
    ///
    ///
    ///
    /// - Parameter row :Int
    /// - Returns: Cell View Model of specific row used in CitiesTableViewController

    func getCellViewModelWithRow(at indexPathRow: Int) -> CitiesCellViewModel {
        return self.citiesCellViewModels[indexPathRow]
    }

    /// This function used to get Cell View Model  used in CityWeatherRecords using indexpath
    ///
    ///
    ///
    /// - Parameter indexPath : IndexPath
    /// - Returns: Cell View Model  used in CityWeatherRecords
    func getCellRecordViewModel(at indexPath: IndexPath) -> CitiesRecordViewModel {
        return self.citiesRecordsCellViewModels[indexPath.row]
    }



    /// This function used to create city record view model used in CityWeatherRecords which is retrieved from Core data
    ///
    ///
    ///
    /// - Parameter record: WeatherInfo
    /// - Returns: CitiesRecordViewModel

    func createCityRecordCellModel(record: WeatherInfo) -> CitiesRecordViewModel {
        var dateRequest = ""
        var temp = 0.0
        var desrip = ""
        var tempC = 0.0
        if let date = record.value(forKey: "requestTime")  as? String{
            dateRequest = date
        }

        if let temp_ = record.value(forKey: "temp")  as? Double{
            temp = temp_
            tempC = temp - 273.15
        }
        if let description = record.value(forKey: "weatherDescription")  as? String{
            desrip = description
        }


        return CitiesRecordViewModel(date: dateRequest, des: desrip, temp: tempC)
    }

    /// This function saves city Names
    ///
    /// ```
    ///
    /// ```
    ///

    /// - Parameter name: city to be saved.
    /// - Parameter completion: The callback called after saving..
    /// - Returns: none.
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

    /// This function saves city weather records
    ///
    /// ```
    ///
    /// ```
    ///

    /// - Parameter weatherInfo: weatherInfo to be saved.
    /// - Parameter completion: The callback called after saving.
    /// - Returns: none.
    func saveWeatherInfo(weatherInfo : CityWeatherInfo,completion: @escaping (Bool,NSManagedObject) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "WeatherInfo", in: managedContext)!
        let city = NSManagedObject(entity: entity, insertInto: managedContext)
        city.setValuesForKeys(["name" : weatherInfo.name, "humidity" : weatherInfo.humidity , "speed" : weatherInfo.speed, "temp" : weatherInfo.temp , "weatherDescription" : weatherInfo.weatherDescription, "iconUrl" : weatherInfo.iconUrl,"requestTime" : self.formateDate(date: Date()),"cityName" : weatherInfo.cityName])
        //        city.seto

        do {
            try managedContext.save()

            completion(true,city)

        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }


    /// This function to fetch weather records by name
    ///
    /// ```
    ///
    /// ```
    ///

    /// - Parameter cityName: cityName to fetch with
    /// - Parameter completion: The callback called after saving.
    /// - Returns: none.
    func fetchWeatherInfoByName(cityName: String) {

        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        do {
            let fetchRequest : NSFetchRequest<WeatherInfo> = WeatherInfo.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "cityName == %@", cityName)
            let fetchedResults = try context.fetch(fetchRequest)

            var vms = [CitiesRecordViewModel]()
            for city in fetchedResults {

                vms.append(createCityRecordCellModel(record: city))
            }
            self.citiesRecordsCellViewModels = vms
            self.reloadTableView?()
        }
        catch {
            print ("fetch task failed", error)
        }

    }


    func fetchWeatherInfoByRecordDate(date: String,cityName:String,completion: @escaping (Bool,NSManagedObject) -> Void) {

        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        do {
            let fetchRequest : NSFetchRequest<WeatherInfo> = WeatherInfo.fetchRequest()
            let predicate1 = NSPredicate(format: "requestTime == %@", date)
            let predicate2 = NSPredicate(format: "cityName == %@", cityName)
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])
            fetchRequest.predicate = compoundPredicate
            let fetchedResults = try context.fetch(fetchRequest)
            if fetchedResults.count > 0 {
                completion(true ,  fetchedResults.first  ?? WeatherInfo() )
            }

            self.reloadTableView?()
        }
        catch {
            print ("fetch task failed", error)
        }

    }


    /// This function to format Date
    ///
    /// ```
    ///
    /// ```
    ///

    /// - Parameter date: Date to formate
    /// - Returns: formated date as String.
    func formateDate(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "d.MM.yyyy h:mm"
        return formatter.string(from: Date())
        
    }

    /// This function to search for City Weather Info from Api and then save to WeatherInfo Entity
    ///
    /// ```
    ///
    /// ```
    ///

    /// - Parameter cityName: city To search with
    ///- Parameter completion: The callback called after retrieing and saving.
    /// - Returns: formated date as String.
    
    func getWeatherInfo(cityName : String,completion: @escaping (Bool,NSManagedObject) -> Void) {
        print("getWeatherInfogetWeatherInfo")
        CityService.citySharedCervice.getWeatherInfo(cityName: cityName) { sucees, weatherInfo, error in
            //
            if sucees{
                if let cityWeatherInfo = weatherInfo{
                    self.saveWeatherInfo(weatherInfo: cityWeatherInfo, completion: {succes,weatherInfo in
                        completion(true,weatherInfo)

                    })
                }
            }else{
                completion(false,WeatherInfo())
            }


        }
    }
}
