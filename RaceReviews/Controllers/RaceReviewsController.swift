//
//  RaceReviewsController.swift
//  RaceReviews
//
//  Created by Alex Paul on 2/12/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit
import MapKit
import FirebaseFirestore

class RaceReviewsController: UIViewController {
  
  @IBOutlet weak var mapView: MKMapView!
  
  private var longPress: UILongPressGestureRecognizer!
  private var raceReviews = [RaceReview]() {
    didSet {
      DispatchQueue.main.async {
        self.makeAnnotations()
      }
    }
  }
  private var annoations = [MKAnnotation]()
  private var listener: ListenerRegistration! // detach listener when no longer needed
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureLongPress()
    mapView.delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    fetchRaceRevies()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(true)
    listener.remove()
  }
  
  private func fetchRaceRevies() {
    // add a listener to observe changes to the firestore database
    raceReviews.removeAll()
    listener = DatabaseManager.firebaseDB.collection(DatabaseKeys.RaceReviewCollectionKey).addSnapshotListener(includeMetadataChanges: true) { (snapshot, error) in
      if let error = error {
        self.showAlert(title: "Network Error", message: error.localizedDescription)
      } else if let snapshot = snapshot {
        var reviews = [RaceReview]()
        for document in snapshot.documents {
          let raceReview = RaceReview(dict: document.data())
          reviews.append(raceReview)
        }
        self.raceReviews = reviews
      }
    }
  }
  
  private func configureLongPress() {
    longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
    longPress.minimumPressDuration = 0.5 // default is 0.5
    mapView.addGestureRecognizer(longPress)
  }
  
  private func makeAnnotations() {
    mapView.removeAnnotations(annoations)
    annoations.removeAll()
    for raceReview in raceReviews {
      let annotation = MKPointAnnotation()
      annotation.coordinate = raceReview.coordinate
      annotation.title = raceReview.name
      annoations.append(annotation)
    }
    mapView.showAnnotations(annoations, animated: true)
  }
  
  @objc private func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
    // get the CGPoint at which the long press was done
    let point = gestureRecognizer.location(in: mapView)
    let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
    var isDone = false
    if !isDone {
      switch gestureRecognizer.state {
      case .began:
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


extension RaceReviewsController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    let detailStoryboard = UIStoryboard(name: "ReviewDetail", bundle: nil)
    guard let reviewDetailController = detailStoryboard.instantiateViewController(withIdentifier: "ReviewDetailController") as? ReviewDetailController else {
      fatalError("ReviewDetailController is nil")
    }
    guard let annotation = view.annotation else {
      fatalError("annotation nil")
    }
    let index = raceReviews.index { $0.coordinate.latitude == annotation.coordinate.latitude
      && $0.coordinate.longitude == $0.coordinate.longitude
    }
    
    if let reviewIndex = index {
      let raceReview = raceReviews[reviewIndex]
      reviewDetailController.raceReview = raceReview
      reviewDetailController.modalPresentationStyle = .overFullScreen
      reviewDetailController.modalTransitionStyle = .crossDissolve
      present(reviewDetailController, animated: true)
    } 
    mapView.deselectAnnotation(annotation, animated: true)
  }
}

