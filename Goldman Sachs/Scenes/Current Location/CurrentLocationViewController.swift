//
//  ViewController.swift
//  Goldman Sachs
//
//  Created by Jai Nijhawan on 30/04/21.
//

import UIKit
import CoreLocation

class CurrentLocationViewController: UIViewController {
  
  // MARK: - IBOutlets
  @IBOutlet weak var cityNameLabel: UILabel!
  
  // Top View
  @IBOutlet weak var temperatureLabel: UILabel!
  @IBOutlet weak var currentWeatherImageView: UIImageView!
  
  // Min Max View
  @IBOutlet weak var minimumTemperatureLabel: UILabel!
  @IBOutlet weak var maximumTemperatureLabel: UILabel!
  
  // Day and Date View
  @IBOutlet weak var dayOfTheWeekLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  
  // Weather Text
  @IBOutlet weak var weatherTextLabel: UILabel!
  
  // Collection Views
  @IBOutlet weak var hourlyWeatherCollectionView: UICollectionView!
  @IBOutlet weak var cityCollectionView: UICollectionView!
  
  
  // MARK: - ViewModel
  var viewModel: CurrentLocationViewModelType!
  var locManager = CLLocationManager()
  
  // MARK: - Lifecycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    locManager.delegate = self
    locManager.requestWhenInUseAuthorization()
    setupUI()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  // MARK: - Custom Methods
  func setupUI() {
    currentWeatherImageView.image = UIImage()
    temperatureLabel.text = "-"
    cityNameLabel.text = "-"
    minimumTemperatureLabel.text = "-"
    maximumTemperatureLabel.text = "-"
    dayOfTheWeekLabel.text = "-"
    dateLabel.text = "-"
    weatherTextLabel.text = "-"
    hourlyWeatherCollectionView.delegate = self
    hourlyWeatherCollectionView.dataSource = self
    cityCollectionView.delegate = self
    cityCollectionView.dataSource = self
    observeChangesInDatabase()
    self.view.layoutIfNeeded()
  }
  
  func observeChangesInDatabase() {
    viewModel.onDatabaseUpdate = { [weak self] in
      if let strongSelf = self {
        DispatchQueue.main.async {
          strongSelf.cityCollectionView.reloadData()
        }
      }
    }
  }
  
  func getDataForLatAndLon(lat: Double, lon: Double) {
    viewModel.getWeatherDataFor(lat: lat, lon: lon) { [weak self] () in
      if let strongSelf = self {
        DispatchQueue.main.async {
          AppHelper.reverseGeoCode(lat: lat, lon: lon) { (name) in
            strongSelf.cityNameLabel.text = name
          }
          strongSelf.populateUI()
        }
      }
    }
  }
  
  func populateUI() {
    guard let model = viewModel.getDataModel else { return }
    temperatureLabel.text = model.temperature
    currentWeatherImageView.image = AppHelper.getImageForCurrentWeatherID(id: model.currentWeatherImageID)
    minimumTemperatureLabel.text = model.minTemperature
    maximumTemperatureLabel.text = model.maximumTemperature
    dayOfTheWeekLabel.text = model.dayOfTheWeek
    dateLabel.text = model.date
    weatherTextLabel.text = model.weatherText
    hourlyWeatherCollectionView.reloadData()
    self.view.layoutIfNeeded()
  }
  
  func showAllowLocationPopup() {
    let alertVC = UIAlertController(title: "Please allow Location Services",
                                    message: "We need location Services to show data",
                                    preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .default) { (_) in
      UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }
    alertVC.addAction(action)
    self.present(alertVC, animated: true, completion: nil)
  }
  
  // MARK: - IBActions
  @IBAction func searchDidTap(_ sender: Any) {
    guard let searchLocationVC = storyboard?
            .instantiateViewController(withIdentifier: ViewControllerIdentifiers.searchLocation.rawValue)
            as? SearchLocationViewController else { return }
    searchLocationVC.viewModel = SearchLocationViewModel(SearchLocationInteractor(SearchCityLocationService(Network())))
    searchLocationVC.modalPresentationStyle = .overFullScreen
    self.present(searchLocationVC, animated: false) {
      searchLocationVC.animateViews()
    }
  }
  
}

extension CurrentLocationViewController: UICollectionViewDelegate,
                                         UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    if collectionView == hourlyWeatherCollectionView {
      return viewModel.getDataModel?.hourlyDataModel.count ?? 0
    }
    
    if collectionView == cityCollectionView {
      return viewModel.getSavedCitiesDataModel.count
    }
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if collectionView == hourlyWeatherCollectionView {
      guard let cell = collectionView
              .dequeueReusableCell(withReuseIdentifier: CurrentLocationVCCells.hourly.rawValue,
                                   for: indexPath)
              as? HourlyWeatherCollectionViewCell else { return UICollectionViewCell() }
      cell.viewModel = viewModel.getDataModel?.hourlyDataModel[indexPath.row]
      return cell
    }
    if collectionView == cityCollectionView {
      guard let cell = collectionView
              .dequeueReusableCell(withReuseIdentifier: CurrentLocationVCCells.city.rawValue,
                                   for: indexPath)
              as? CityCollectionViewCell else { return UICollectionViewCell() }
      cell.viewModel = viewModel.getSavedCitiesDataModel[indexPath.row]
      return cell
    }
    return UICollectionViewCell()
  }
}

extension CurrentLocationViewController: CLLocationManagerDelegate {
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    let status = manager.authorizationStatus
    if status == .authorizedWhenInUse || status == .authorizedAlways {
      guard let currentLocation = manager.location
      else { return }
      let lat = Double(currentLocation.coordinate.latitude)
      let lon = Double(currentLocation.coordinate.longitude)
      getDataForLatAndLon(lat: lat, lon: lon)
    } else if status == .denied || status == .restricted {
      showAllowLocationPopup()
    }
  }
}
