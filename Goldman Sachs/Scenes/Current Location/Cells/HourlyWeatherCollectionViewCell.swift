//
//  HourlyWeatherCollectionViewCell.swift
//  Goldman Sachs
//
//  Created by Jai Nijhawan on 30/04/21.
//

import UIKit

class HourlyWeatherCollectionViewCell: UICollectionViewCell {
    
  @IBOutlet weak var dataStackView: UIStackView!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var weatherImage: UIImageView!
  @IBOutlet weak var temperatureLabel: UILabel!
  //Next Day Outlets
  @IBOutlet weak var nextDayView: UIView!
  @IBOutlet weak var nextDayLabel: UILabel!
  
  var viewModel: HourlyWeatherCollectionViewCellModel? {
    didSet {
      if viewModel?.index == 0 {
        timeLabel.text = "NOW"
      } else {
        timeLabel.text = viewModel?.time
      }
      weatherImage.image = AppHelper.getImageForCurrentWeatherID(id: viewModel!.id)
      temperatureLabel.text = viewModel?.temperature
      if viewModel?.id == 0 {
        nextDayView.alpha = 1
        dataStackView.alpha = 0
      } else {
        nextDayView.alpha = 0
        dataStackView.alpha = 1
      }
    }
  }
}
