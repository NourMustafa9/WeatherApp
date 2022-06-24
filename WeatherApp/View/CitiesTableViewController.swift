//
//  CitiesTableViewController.swift
//  WeatherApp
//
//  Created by Nour_Madar on 23/06/2022.
//

import UIKit
import SVProgressHUD


class CitiesTableViewController: UITableViewController {

    // MARK: - Variables
    var topColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    var bottomColor = #colorLiteral(red: 0.8392156863, green: 0.8274509804, blue: 0.8705882353, alpha: 1)
var searchColor = #colorLiteral(red: 0.137254902, green: 0.5333333333, blue: 0.7803921569, alpha: 1)
    lazy var viewModel = {
        CityViewModel()
    }()

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpViews()


    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.retrieveCities()
        viewModel.retrieveCitiesWeatherInfo()
    }

    // MARK: - Func

    func setUpViews(){
        self.tableView.tableHeaderView = UIView()
        self.additionalSafeAreaInsets.top = 35
        self.title = "Cities"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "SFProText-Bold", size: 17)!,NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.2392156863, green: 0.2705882353, blue: 0.2823529412, alpha: 1)]
        self.tableView.setGradientBackground(topColor: topColor, bottomColor: bottomColor)
        let rightButton = UIButton()
           rightButton.setTitle("   +    ", for: .normal)
        rightButton.setTitleColor(.white, for: .normal)
        rightButton.layer.cornerRadius = 9
        if #available(iOS 11.0, *) {
            rightButton.layer.maskedCorners = [.layerMinXMinYCorner,.layerMinXMaxYCorner]
           // nonetImg.layer.maskedCorners = [.layerMinXMaxYCorner]
        }
        rightButton.addTarget(self, action: #selector(CitiesTableViewController.openCitySearchBottomSheet), for: .touchUpInside)
           navigationController?.navigationBar.addSubview(rightButton)
           rightButton.tag = 1
           rightButton.frame = CGRect(x: self.view.frame.width, y: 5, width: 73, height: 20)
        rightButton.backgroundColor = searchColor
           let targetView = self.navigationController?.navigationBar

           let trailingContraint = NSLayoutConstraint(item: rightButton, attribute:
               .trailingMargin, relatedBy: .equal, toItem: targetView,
                                attribute: .trailingMargin, multiplier: 1.0, constant: 5)
           let bottomConstraint = NSLayoutConstraint(item: rightButton, attribute: .bottom, relatedBy: .equal,
                                           toItem: targetView, attribute: .bottom, multiplier: 1.0, constant: 0)

        let height = NSLayoutConstraint(item: rightButton, attribute: .height, relatedBy: .equal,
                                        toItem: targetView, attribute: .height, multiplier: 1.0, constant: 0)
        let width = NSLayoutConstraint(item: rightButton, attribute: .width, relatedBy: .equal,
                                       toItem: targetView, attribute: .width, multiplier: 0.2, constant: 0)

           rightButton.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([trailingContraint, bottomConstraint,height,width])
    }
    func initViewModel() {
        viewModel.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()////
            }
        }
    }
    @objc func openCitySearchBottomSheet(){
        self.presentModal()

    }
    func saveCity(city: String,completion: @escaping (Bool) -> Void) {
        viewModel.save(name: city, completion:{_ in
            self.viewModel.retrieveCities()
            self.tableView.reloadData()

            completion(true)
        })

    }
    private func presentModal() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BottomSheetViewController") as! BottomSheetViewController
        vc.searchDelegate = self
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
        }
        present(nav, animated: true, completion: nil)

    }
    func getCityWeatherInfo(city: String){
        SVProgressHUD.show()
        self.viewModel.getWeatherInfo(cityName: city, completion: {
            [weak self] success,cityInfo  in
            self?.performSegue(withIdentifier: "goToDetails", sender: self)
            SVProgressHUD.dismiss()
        })
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.viewModel.citiesCellViewModels.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "citiesCell", for: indexPath) as! CitiesTableViewCell
        let cellVM = viewModel.getCellViewModel(at: indexPath)
        cell.cellViewModel = cellVM
        cell.cellAudioButton.tag = indexPath.row

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
        let name = viewModel.getCellViewModel(at: indexPath)
        self.getCityWeatherInfo(city: name.name)
    }

}
extension CitiesTableViewController:CityWeather{
    func GetCityWeather(_ city: String) {
        
        self.saveCity(city: city, completion: {
            _ in

        })
    }
}
