//
//  CityWeatherRecordViewController.swift
//  WeatherApp
//
//  Created by Nour_Madar on 25/06/2022.
//

import UIKit
import CoreData

class CityWeatherRecordViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    // MARK: - IBOutlet
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var cityRecords: UILabel!
    @IBOutlet weak var tableView: UITableView!
    // MARK: - Variables
    var cityName = ""
    var cityWeatherInfo = NSManagedObject()
    var topColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    var bottomColor = #colorLiteral(red: 0.8392156863, green: 0.8274509804, blue: 0.8705882353, alpha: 1)
    lazy var viewModel = {
        CityViewModel()
    }()
    // MARK: - Views Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cityRecords.text = cityName +  " Historical"
        self.cityRecords.setLineSpacing(lineSpacing: 3, lineHeightMultiple: 0, font: UIFont.SFProTextBold17)
        self.cityRecords.textAlignment = .center
        registerCell()
        viewModel.fetchWeatherInfoByName(cityName: self.cityName)
        self.view.setViewGradientBackground(topColor: self.topColor, bottomColor: self.bottomColor)
        backView.layer.cornerRadius = 20
        if #available(iOS 11.0, *) {
            backView.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMaxXMinYCorner]
            // nonetImg.layer.maskedCorners = [.layerMinXMaxYCorner]
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    // MARK: - funcs
    func registerCell(){
        self.tableView.register(UINib(nibName:"CityRecordTableViewCell", bundle: nil), forCellReuseIdentifier: "CityRecordTableViewCell")
    }
    // MARK: - IBAction
    @IBAction func backView(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToRecordDetails"{
            (segue.destination as! WeatherInfoDetailsViewController).cityWeatherInfo =  self.cityWeatherInfo
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    // MARK: - Tableview Delegates , DataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "CityRecordTableViewCell", for: indexPath) as! CityRecordTableViewCell

        let cellVM = viewModel.getCellRecordViewModel(at: indexPath)

        cell.cellViewModel = cellVM
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let date = viewModel.getCellRecordViewModel(at: indexPath)
        self.viewModel.fetchWeatherInfoByRecordDate(date: date.date, cityName: self.cityName) { res, weatherInfo in
            self.cityWeatherInfo = weatherInfo
            self.performSegue(withIdentifier: "goToRecordDetails", sender: self)
            print(weatherInfo.value(forKey: "requestTime"))
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.citiesRecordsCellViewModels.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
