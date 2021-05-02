//
//  SearchLocationViewController.swift
//  Goldman Sachs
//
//  Created by Jai Nijhawan on 01/05/21.
//

import UIKit

class SearchLocationViewController: UIViewController {
  
  // MARK: - IBOutlets
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var searchViewTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var blurView: UIVisualEffectView!
  @IBOutlet weak var cityTableView: UITableView!
  
  // MARK: - Variables
  var debounceTimer:Timer?
  
  // MARK: - ViewModel
  var viewModel: SearchLocationViewModelType!
  
  // MARK: - Lifecycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  // MARK: - Custom Methods
  func setupUI() {
    let attributedString = NSAttributedString(string: "Search City",
                                              attributes: [NSAttributedString.Key.foregroundColor:UIColor.white])
    searchBar.searchTextField.attributedPlaceholder = attributedString
    searchViewTopConstraint.constant = -300
    cityTableView.alpha = 0
    blurView.alpha = 0
    searchBar.searchTextField.leftView?.tintColor = .white
    searchBar.delegate = self
    cityTableView.delegate = self
    cityTableView.dataSource = self
  }
  
  func animateViews(present: Bool = true) {
    searchViewTopConstraint.constant = present ? 50 : -300
    UIView.animate(withDuration: 0.8,
                   delay: 0,
                   usingSpringWithDamping: 0.8,
                   initialSpringVelocity: 2,
                   options: .curveEaseInOut,
                   animations: {
                    self.blurView.alpha = present ? 1 : 0
                    self.cityTableView.alpha = 0
                    self.view.layoutIfNeeded()
                   },
                   completion: { _ in
                    if !present {
                      self.dismiss(animated: false, completion: nil)
                    }
                   })
  }
  
  func updateTableViewData(for input: String) {
    viewModel.getDataFor(name: input) { [weak self] in
      if let strongSelf = self {
        strongSelf.reloadTableViewData()
      }
    }
  }
  
  func reloadTableViewData() {
    DispatchQueue.main.async {
      UIView.animate(withDuration: 0.25) {
        self.cityTableView.alpha = 1
      }
      self.cityTableView.reloadData()
    }
  }
  
  // MARK: - IBActions
  @IBAction func backDidTap(_ sender: Any) {
    view.endEditing(true)
    animateViews(present: false)
  }
}

extension SearchLocationViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    viewModel.cityNames?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView
            .dequeueReusableCell(withIdentifier: SearchLocationVCCells.searchLocationCell.rawValue,
                                 for: indexPath) as? SearchLocationTableViewCell else {
      return UITableViewCell()
    }
    cell.setupUI(name: viewModel.cityNames?[indexPath.row].description ?? "")
    return cell
  }
  
  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath) {
    guard let cityDetailVC = storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.cityDetail.rawValue) as? CityDetailViewController else { return }
    cityDetailVC.viewModel = CityDetailViewModel(CityDetailInteractor(CityWeatherService(Network())),
                                                 viewModel.cityNames?[indexPath.row].actualName ?? "",
                                                 PersistenceService())
    self.present(cityDetailVC, animated: true, completion: nil)
  }
}

extension SearchLocationViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    debounceTimer?.invalidate()
    debounceTimer = Timer.scheduledTimer(withTimeInterval: 1.0,
                                         repeats: false) { _ in
      self.updateTableViewData(for: searchText)
    }
  }
}
