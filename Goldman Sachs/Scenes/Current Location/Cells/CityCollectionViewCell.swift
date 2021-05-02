//
//  CityCollectionViewCell.swift
//  YAWA - Yet Another Weather App
//
//  Created by Jai Nijhawan on 18/07/20.
//  Copyright © 2020 Jai Nijhawan. All rights reserved.
//

import UIKit

class CityCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var cityName: UILabel!
  @IBOutlet weak var temperature: UILabel!
  @IBOutlet weak var weatherImage: UIImageView!
  @IBOutlet weak var addMoreCitiesView: UIView!
  
  var viewModel: CityCollectionViewCellModel? {
    didSet {
      cityName.text = viewModel?.cityName
      temperature.text = viewModel?.temperature
      weatherImage.image = AppHelper.getImageForCurrentWeatherID(id: viewModel?.id ?? 0)
    }
  }
  
  
}
