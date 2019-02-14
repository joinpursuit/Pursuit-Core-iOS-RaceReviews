//
//  AddRaceReviewController.swift
//  RaceReviews
//
//  Created by Alex Paul on 2/13/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit
import CoreLocation

class AddRaceReviewController: UIViewController {
  
  @IBOutlet var addRaceReview: AddRaceReview!
  
  private var raceTypes = [RaceType]()
  private var raceReviewPlaceholderText = "enter your race review"
  private var selectedRaceType = "\(RaceType.allCases[0])" // default to first race type 
  private var usersession: UserSession!
  
  public var coordinate: CLLocationCoordinate2D!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addRaceReview.raceTypePickerView.dataSource = self
    addRaceReview.raceTypePickerView.delegate = self
    addRaceReview.raceNameTextField.becomeFirstResponder()
    configureTextView()
    usersession = (UIApplication.shared.delegate as! AppDelegate).usersession
  }
  
  private func configureTextView() {
    addRaceReview.reviewTextView.delegate = self
    addRaceReview.reviewTextView.text = raceReviewPlaceholderText
    addRaceReview.reviewTextView.textColor = .lightGray
  }
  
  @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
    dismiss(animated: true)
  }
  
  // function to create RaceReview and post to the database
  @IBAction func addRaceReviewButtonPressed(_ sender: UIBarButtonItem) {
    guard let user = usersession.getCurrentUser() else {
      showAlert(title: "Not Authenticated!", message: "no logged user")
      return
    }
    // all required to create a RaceReview()
    guard let raceName = addRaceReview.raceNameTextField.text,
      let review = addRaceReview.reviewTextView.text,
      !raceName.isEmpty,
      !review.isEmpty else {
        showAlert(title: "Missing Fields", message: "Race Name and Review Required")
        return
    }
    
    // create a RaceReview()
    let raceReview = RaceReview(name: raceName,
                                review: review,
                                type: selectedRaceType,
                                lat: coordinate.latitude,
                                lon: coordinate.longitude,
                                reviewerId: user.uid,
                                dbReference: "") // reference will be set after document is created
    DatabaseManager.postRaceReviewToDatabase(raceReview: raceReview)
    showAlert(title: "Race Review Created", message: "Successfully created \(raceReview.name) race review",  style: .alert) { (alertController) in
      let okAction = UIAlertAction(title: "Ok", style: .default) { alert in
        self.dismiss(animated: true)
      }
      alertController.addAction(okAction)
      self.present(alertController, animated: true)
    }
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
    selectedRaceType = "\(RaceType.allCases[row])"
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
