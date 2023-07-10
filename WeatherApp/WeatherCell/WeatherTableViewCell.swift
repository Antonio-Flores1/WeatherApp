//
//  WeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Antonio on 7/10/23.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        
    }
    
    static let identifier = "WeatherTableViewCell"
    
    static func nib() -> UINib {
     return UINib(nibName: "HourlyTableViewCell", bundle: nil)
    }
    
}
