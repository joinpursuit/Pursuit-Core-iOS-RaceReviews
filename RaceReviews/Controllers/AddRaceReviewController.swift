//
//  AddRaceReviewController.swift
//  RaceReviews
//
//  Created by Alex Paul on 2/13/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

class AddRaceReviewController: UIViewController {
  
  @IBOutlet var addRaceReview: AddRaceReview!
  
  private var raceTypes = [RaceType]()
  private var raceReviewPlaceholderText = "enter your race review"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addRaceReview.raceTypePickerView.dataSource = self
    addRaceReview.raceTypePickerView.delegate = self
    addRaceReview.raceNameTextField.becomeFirstResponder()
    configureTextView()
  }
  
  private func configureTextView() {
    addRaceReview.reviewTextView.delegate = self
    addRaceReview.reviewTextView.text = raceReviewPlaceholderText
    addRaceReview.reviewTextView.textColor = .lightGray
  }
  
  @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
    dismiss(animated: true)
  }
  
  @IBAction func addRaceReviewButtonPressed(_ sender: UIBarButtonItem) {
    dismiss(animated: true)
  }
}

extension AddRaceReviewController: UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return RaceType.allCases.count
  }
}

extension AddRaceReviewController: UIPickerViewDelegate {
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return "\(RaceType.allCases[row])"
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    print("selected race type: \(RaceType.allCases[row])")
  }
}

extension AddRaceReviewController: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.text == raceReviewPlaceholderText {
      textView.textColor = .black
      textView.text = ""
    }
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text == "" {
      textView.textColor = .lightGray
      textView.text = raceReviewPlaceholderText
    }
  }
}
