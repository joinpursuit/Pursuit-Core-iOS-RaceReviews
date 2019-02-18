//
//  LocationsResultsControllerViewController.swift
//  RaceReviews
//
//  Created by Alex Paul on 2/16/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit
import MapKit

protocol LocationResultsControllerDelegate: AnyObject {
  func didSelectCoordinate(_ locationResultsController: LocationsResultsController, coordinate: CLLocationCoordinate2D)
  func didScrollTableView(_ locationResultsController: LocationsResultsController)
}

class LocationsResultsController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  
  private let searchCompleter = MKLocalSearchCompleter()
  private var completerResults: [MKLocalSearchCompletion]?
  
  weak var delegate: LocationResultsControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate = self
    
    searchCompleter.delegate = self
  }
}

extension LocationsResultsController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return completerResults?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)
    
    if let suggestion = completerResults?[indexPath.row] {
      // Each suggestion is a MKLocalSearchCompletion with a title, subtitle
      cell.textLabel?.text = suggestion.title
      cell.detailTextLabel?.text = suggestion.subtitle
    }
    return cell
  }
}

extension LocationsResultsController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let suggestion = completerResults?[indexPath.row] {
      let addressString = suggestion.subtitle.isEmpty ? suggestion.title : suggestion.subtitle
      LocationService.getCoordinate(addressString: addressString) { (coordinate, error) in
        if let error = error {
          print("error getting coordinate: \(error)")
        } else {
          print(coordinate)
          self.delegate?.didSelectCoordinate(self, coordinate: coordinate)
        }
      }
    }
    dismiss(animated: true)
  }
}

extension LocationsResultsController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    // Ask `MKLocalSearchCompleter` for new completion suggestions based on the change in the text entered in `UISearchBar`.
    searchCompleter.queryFragment = searchController.searchBar.text ?? ""
  }
}

extension LocationsResultsController: MKLocalSearchCompleterDelegate {
  /// - Tag: QueryResults
  func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
    // As the user types, new completion suggestions are continuously returned to this method.
    // Overwrite the existing results, and then refresh the UI with the new results.
    completerResults = completer.results
    tableView.reloadData()
  }
  
  func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
    // Handle any errors returned from MKLocalSearchCompleter.
    if let error = error as NSError? {
      print("MKLocalSearchCompleter encountered an error: \(error.localizedDescription)")
    }
  }
}

extension LocationsResultsController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    delegate?.didScrollTableView(self)
  }
}
