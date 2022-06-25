//
//  CitiesTableViewCell.swift
//  WeatherApp
//
//  Created by Nour_Madar on 24/06/2022.
//

import UIKit

class CitiesTableViewCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var cityName: UILabel!

    // MARK: - Variables
    let cellAudioButton = UIButton(type: .custom)
    var cellViewModel: CitiesCellViewModel? {
        didSet {
            cityName.text = cellViewModel?.name
        }

    }
    // MARK: - Views Funcs
    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
        // Initialization code

    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func initView(){

        cellAudioButton.frame = CGRect(x: 0, y: 0, width: 16, height: 22)
        cellAudioButton.setImage(UIImage(named: "right-arrow-"), for: .normal)
        cellAudioButton.contentMode = .scaleAspectFit

        self.accessoryView = cellAudioButton as UIView
    }
}
