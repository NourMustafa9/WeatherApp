//
//  BottomSheetViewController.swift
//  WeatherApp
//
//  Created by Nour_Madar on 24/06/2022.
//

import UIKit
protocol CityWeather : AnyObject{
    func GetCityWeather(_ city: String)
}
class BottomSheetViewController: UIViewController , UISearchBarDelegate{
    @IBOutlet weak var searchCity: UISearchBar!
    var topColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    var bottomColor = #colorLiteral(red: 0.8392156863, green: 0.8274509804, blue: 0.8705882353, alpha: 1)
    var searchActive = false
    weak var searchDelegate : CityWeather?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpViews()
        // Do any additional setup after loading the view.
    }
    
    func setUpViews(){

        self.title = "Enter city"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "SFProText-Regular", size: 13)!,NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.2392156863, green: 0.2705882353, blue: 0.2823529412, alpha: 1)]
        print("view did load")
        self.searchCity.delegate = self
        self.searchCity.returnKeyType = .search
        self.searchCity.textContentType = .location
        self.view.setViewGradientBackground(topColor: topColor, bottomColor: bottomColor)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
         searchActive = true
     }

     func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
         searchActive = false
     }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
         searchActive = false;

         searchBar.text = nil
         searchBar.resignFirstResponder()

     }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
         searchActive = false
        if let searchText = searchBar.text{
            self.dismiss(animated: true)
            self.searchDelegate?.GetCityWeather(searchText)
        }
     }

    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
                 return true
     }


    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
             self.searchActive = true;
             self.searchCity.showsCancelButton = true

     }

}
