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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    DatabaseManager.postRaceReviewToDatabase()
  }
}
