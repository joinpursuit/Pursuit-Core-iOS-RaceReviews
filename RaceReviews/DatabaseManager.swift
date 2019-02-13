//
//  DatabaseManager.swift
//  RaceReviews
//
//  Created by Alex Paul on 2/12/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class DatabaseManager {
  
  private init() {}
  
  static let firebaseDB: Firestore = {
    // gets a reference to Cloud Firestore database    
    let db = Firestore.firestore()
    let settings = db.settings
    settings.areTimestampsInSnapshotsEnabled = true
    db.settings = settings
    
    return db
  }()
  
  static func postRaceReviewToDatabase(raceReview: RaceReview) {
    var ref: DocumentReference? = nil
    ref = firebaseDB.collection("raceReviews").addDocument(data: ["raceName"    : raceReview.name,
                                                                  "raceReview"  : raceReview.review,
                                                                  "reviewerId"  : raceReview.reviewerId,
                                                                  "latitude"    : raceReview.lat,
                                                                  "longitude"   : raceReview.lon,
                                                                  "raceType"    :  raceReview.type
      ], completion: { (error) in
      if let error = error {
        print("posing race failed with error: \(error)")
      } else {
        print("post created at ref: \(ref?.documentID ?? "no doc id")")
      }
    })
  }
  
}
