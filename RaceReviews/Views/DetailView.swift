//
//  DetailView.swift
//  RaceReviews
//
//  Created by Alex Paul on 2/13/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

class DetailView: UIView {
  
  @IBOutlet var contentView: UIView!
  @IBOutlet weak var raceNameLabel: UILabel!
  @IBOutlet weak var raceReviewTextView: UITextView!
  @IBOutlet weak var dismissButton: UIButton!
  @IBOutlet weak var deleteButton: UIButton!
  @IBOutlet weak var usernameLabel: UILabel!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  private func commonInit() {
    Bundle.main.loadNibNamed("DetailView", owner: self, options: nil)
    addSubview(contentView)
    contentView.frame = bounds
    contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    detailViewDefaultState()
  }
  
  private func detailViewDefaultState() {
    deleteButton.isHidden = true
    raceReviewTextView.isEditable = false
  }
  
  
}
