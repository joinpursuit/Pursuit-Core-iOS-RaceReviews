//
//  RRUser.swift
//  RaceReviews
//
//  Created by Alex Paul on 2/15/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import Foundation

struct RRUser {
  let username: String?
  let imageURL: String?
  
  init(dict: [String: Any]) {
    self.username = dict["username"] as? String ?? "no username"
    self.imageURL = dict["imageURL"] as? String ?? "no imageURL"
  }
}
