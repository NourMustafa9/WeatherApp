//
//  CityRecordTableViewCell.swift
//  WeatherApp
//
//  Created by Nour_Madar on 25/06/2022.
//

import UIKit

class CityRecordTableViewCell: UITableViewCell {

    @IBOutlet weak var descRip: UILabel!
    @IBOutlet weak var requestTIme: UILabel!
    var cellViewModel: CitiesRecordViewModel? {
        didSet {
            requestTIme.text = cellViewModel?.date

            descRip.text = (cellViewModel?.des ?? "") + " , " + String(format: "%.2f",cellViewModel?.temp ?? 0.0) + "°C"
        }

    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
