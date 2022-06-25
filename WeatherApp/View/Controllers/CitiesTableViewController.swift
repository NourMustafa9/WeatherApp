//
//  CitiesTableViewController.swift
//  WeatherApp
//
//  Created by Nour_Madar on 23/06/2022.
//

import UIKit
import SVProgressHUD
import CoreData
/// This is App rootClass with an array of city names saved in Core Data if didselected city will go to City Info Controller and if clicked on cell accessory will go to City Weather Info records.
///
/// ```
///
/// ```
///



class CitiesTableViewController: UITableViewController {

    // MARK: - Variables
    var topColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    var bottomColor = #colorLiteral(red: 0.8392156863, green: 0.8274509804, blue: 0.8705882353, alpha: 1)
    var searchColor = #colorLiteral(red: 0.137254902, green: 0.5333333333, blue: 0.7803921569, alpha: 1)
    var bgImg = UIImageView()
    var cityWeatherInfo = NSManagedObject()
    lazy var viewModel = {
        CityViewModel()
    }()

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpViews()
        self.setUpNavigationBar()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.retrieveCities()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    // MARK: - Func

    func setUpViews(){
        self.tableView.tableHeaderView = UIView()
        self.tableView.setGradientBackground(topColor: topColor, bottomColor: bottomColor)
        self.addBgImgView()
    }
    func addBgImgView(){
        bgImg.frame = CGRect(x: 0, y: self.tableView.frame.maxY - 290 , width: self.view.frame.width, height: 240)
        bgImg.image = UIImage(named: "Background")
        self.view.addSubview(bgImg)
        self.tableView.bringSubviewToFront(bgImg)
    }
    func setUpNavigationBar(){
        self.additionalSafeAreaInsets.top = 35
        self.title = "Cities"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "SFProText-Bold", size: 17)!,NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.2392156863, green: 0.2705882353, blue: 0.2823529412, alpha: 1)]
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
        var cityName = city

        self.viewModel.getWeatherInfo(cityName: cityName, completion: {
            [weak self] success,cityInfo  in
            SVProgressHUD.dismiss()
            if success{
                self?.cityWeatherInfo = cityInfo
                self?.performSegue(withIdentifier: "goToDetails", sender: self)
            }else{
                self?.showAlert(cityName: cityName)
            }


        })
    }

    func showAlert(cityName: String){
              let alert = UIAlertController(title: "Error", message: "Please type valid city", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: {_ in 
                  self.deleteFeed(cityName: cityName)
              }))
              self.present(alert, animated: true, completion: nil)
    }
    @objc func gotToRecords(_ sender: UIButton!) {
           let btnsendtag: UIButton = sender
        let cellVM = viewModel.getCellViewModelWithRow(at: btnsendtag.tag)
        print(cellVM.name)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let vc = storyboard.instantiateViewController(withIdentifier: "CityWeatherRecordViewController") as! CityWeatherRecordViewController
        vc.cityName = cellVM.name
        self.navigationController?.pushViewController(vc, animated: true)
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetails"{
            (segue.destination as! WeatherInfoDetailsViewController).cityWeatherInfo =  self.cityWeatherInfo
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
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
        cell.cellAudioButton.addTarget(self, action: #selector(gotToRecords), for: .touchUpInside)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
        let name = viewModel.getCellViewModel(at: indexPath)
        self.getCityWeatherInfo(city: name.name)
    }
    func deleteFeed(cityName:String)
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        do {
            let fetchRequest : NSFetchRequest<City> = City.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "name == %@", cityName)
            let fetchedResults = try context.fetch(fetchRequest)
            do
              {


                  for entity in fetchedResults {

                      context.delete(entity)
                  }
                  self.viewModel.retrieveCities()
                  self.tableView.reloadData()
                  
              }
              catch _ {
                  print("Could not delete")

              }
        }
        catch _ {
            print("Could not delete")

        }
    }
}
extension CitiesTableViewController:CityWeather{
    func GetCityWeather(_ city: String) {
        
        self.saveCity(city: city, completion: {
            _ in

        })
    }
}
