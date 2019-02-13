//
//  RaceReview.swift
//  RaceReviews
//
//  Created by Alex Paul on 2/13/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import Foundation
import CoreLocation

enum RaceType: CaseIterable {
  case swimming
  case biking
  case running
  case obstacle
  case other
}

struct RaceReview {
  let name: String
  let review: String
  let type: RaceType
  let lat: Double
  let lon: Double
  let reviewerId: String
  
  init(name: String, review: String, type: RaceType, lat: Double, lon: Double, reviewerId: String) {
    self.name = name
    self.review = review
    self.type = type
    self.lat = lat
    self.lon = lon
    self.reviewerId = reviewerId
  }
  
  init(dict: [String: Any]) {
    self.name = dict["name"] as? String ?? "no race name"
    self.review = dict["review"] as? String ?? "no race review"
    self.type = dict["type"] as? RaceType ?? .other
    self.lat = dict["lat"] as? Double ?? 0
    self.lon = dict["lon"] as? Double ?? 0
    self.reviewerId = dict["reviewerId"] as? String ?? "no reviewerId"
  }
  
  public var coordinate: CLLocationCoordinate2D {
    return CLLocationCoordinate2DMake(lat, lon)
  }
}
