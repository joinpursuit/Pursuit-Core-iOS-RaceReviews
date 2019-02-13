//
//  AddRaceReview.swift
//  RaceReviews
//
//  Created by Alex Paul on 2/13/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

class AddRaceReview: UIView {
  
  @IBOutlet var contentView: UIView!
  @IBOutlet weak var raceNameTextField: UITextField!
  @IBOutlet weak var reviewTextView: UITextView!
  @IBOutlet weak var raceTypePickerView: UIPickerView!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  private func commonInit() {
    Bundle.main.loadNibNamed("AddRaceReview", owner: self, options: nil)
    addSubview(contentView)
    contentView.frame = bounds
    contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
  }  
}
