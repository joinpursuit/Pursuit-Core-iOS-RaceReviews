//
//  RaceReviewsController.swift
//  RaceReviews
//
//  Created by Alex Paul on 2/12/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit
import MapKit

class RaceReviewsController: UIViewController {
  
  @IBOutlet weak var mapView: MKMapView!
  
  private var longPress: UILongPressGestureRecognizer!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureLongPress()
  }
  
  private func configureLongPress() {
    longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
    longPress.minimumPressDuration = 0.5 // default is 0.5
    mapView.addGestureRecognizer(longPress)
  }
  
  @objc private func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
    // returns point of interaction
    let point = gestureRecognizer.location(in: mapView)
    let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
    var isDone = false
    if !isDone {
      switch gestureRecognizer.state {
      case .began:
        print("long press activated....")
        print(coordinate)
        presentAddRaceReview(coordinate: coordinate)
        isDone = true
        break
      default:
        break
      }
    }
  }
  
  private func presentAddRaceReview(coordinate: CLLocationCoordinate2D) {
    let tabStoryboard = UIStoryboard(name: "RaceReviewsTab", bundle: nil)
    let addReviewsNavController = tabStoryboard.instantiateViewController(withIdentifier: "AddRaceReviewNavController") as! UINavigationController
    guard let addRaceReviewsController = addReviewsNavController.viewControllers.first as? AddRaceReviewController else {
      fatalError("AddRaceReviewController is nil")
    }
    addRaceReviewsController.coordinate = coordinate
    present(addReviewsNavController, animated: true)
  }
}
