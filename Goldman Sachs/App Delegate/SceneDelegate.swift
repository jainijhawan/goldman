//
//  SceneDelegate.swift
//  Goldman Sachs
//
//  Created by Jai Nijhawan on 30/04/21.
//

import UIKit

enum ViewControllerIdentifiers: String {
  case currentLocation = "CurrentLocationViewController"
  case searchLocation = "SearchLocationViewController"
  case cityDetail = "CityDetailViewController"
}
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  // MARK: - Window
  var window: UIWindow?
  
  func scene(_ scene: UIScene,
             willConnectTo session: UISceneSession,
             options connectionOptions: UIScene.ConnectionOptions) {
    guard let scene = (scene as? UIWindowScene) else { return }
    window = UIWindow(windowScene: scene)
    window?.makeKeyAndVisible()
    let currentLocationViewController = UIStoryboard(name: "Main", bundle: nil)
      .instantiateViewController(withIdentifier: ViewControllerIdentifiers.currentLocation.rawValue) as? CurrentLocationViewController
    let viewModel = CurrentLocationViewModel(CurrentLocationInteractor(CurrentLocationService(Network()),
                                                                       PersistenceService(),
                                                                       CityWeatherService(Network())))
    currentLocationViewController?.viewModel = viewModel
    window?.rootViewController = currentLocationViewController
  }
}

