//
//  SearchLocationTableViewCell.swift
//  Goldman Sachs
//
//  Created by Jai Nijhawan on 02/05/21.
//

import UIKit

class SearchLocationTableViewCell: UITableViewCell {
  // MARK: - IBOutlets
  @IBOutlet weak var cityNameLabel: UILabel!
  
  func setupUI(name: String) {
    cityNameLabel.text = name
    selectionStyle = .none
  }
}
