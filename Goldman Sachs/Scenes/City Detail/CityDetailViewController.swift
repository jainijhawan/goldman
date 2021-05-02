//
//  CityDetailViewController.swift
//  Goldman Sachs
//
//  Created by Jai Nijhawan on 02/05/21.
//

import UIKit

class CityDetailViewController: UIViewController {
  
  // MARK: - IBOutlets
  @IBOutlet weak var weatherIcon: UIImageView!
  @IBOutlet weak var cityNameLabel: UILabel!
  @IBOutlet weak var temperatureLabel: UILabel!
  @IBOutlet weak var addToPlacesButton: UIButton!
  
  // MARK: - ViewModel
  var viewModel: CityDetailViewModelType!
  
  // MARK: - Lifecycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  // MARK: - Custom Methods
  func setupUI() {
    self.viewModel.getWeatherDataForCity { [weak self] (cityWeatherModel) in
      if let strongSelf = self {
        strongSelf.populateUI(cityWeatherModel)
      }
    }
  }
  
  func populateUI(_ cityWeatherModel: CityWeatherModel) {
    DispatchQueue.main.async {
      self.weatherIcon.image = AppHelper.getImageForCurrentWeatherID(id: cityWeatherModel.weather.first?.id ?? 0)
      self.cityNameLabel.text = cityWeatherModel.name
      self.temperatureLabel.text = cityWeatherModel.main.temp.getTempInCelcius() + "°C"
      self.view.layoutIfNeeded()
    }
  }
  
  // MARK: - IBActions
  @IBAction func addToPlacesTapped(_ sender: Any) {
    viewModel.saveCityToDatabse()
    let alertVC = UIAlertController(title: "Saved to My Places",
                                    message: cityNameLabel.text ?? "",
                                    preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .default)
    alertVC.addAction(action)
    self.present(alertVC, animated: true, completion: nil)
    addToPlacesButton.isUserInteractionEnabled = false
  }
  
  @IBAction func backDidTap(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
}
