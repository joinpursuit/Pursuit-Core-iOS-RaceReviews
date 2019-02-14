//
//  ReviewDetailController.swift
//  RaceReviews
//
//  Created by Alex Paul on 2/13/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

private enum EditingState {
  case authorizedForEditing
  case notAuthorizedForEditing
}

class ReviewDetailController: UIViewController {
  
  @IBOutlet var detailView: DetailView!
  
  public var raceReview: RaceReview!
  
  private var editingState = EditingState.notAuthorizedForEditing
  private var usersession: UserSession!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .clear
    usersession = (UIApplication.shared.delegate as! AppDelegate).usersession
    if let user = usersession.getCurrentUser() {
      editingState = user.uid == raceReview.reviewerId ? .authorizedForEditing : .notAuthorizedForEditing
    }
    updateDetailView()
    queryForReviewer()
  }
  
  private func queryForReviewer() {
    // Query - for the user who created this race review
    let query = DatabaseManager.firebaseDB.collection(DatabaseKeys
      .UsersCollectionKey).whereField("userId", isEqualTo: raceReview.reviewerId)
    query.getDocuments { (snapshot, error) in
      if let error = error {
        self.showAlert(title: "Network Error", message: error.localizedDescription)
      } else if let snapshot = snapshot {
        guard let firstDocument = snapshot.documents.first else {
          print("no document found")
          return
        }
        if let username = firstDocument.data()["username"] as? String {
          self.detailView.usernameLabel.text = "reviewed by @\(username)"
        }
      }
    }
  }
  
  private func updateDetailView() {
    detailView.usernameLabel.text = ""
    detailView.raceNameLabel.text = raceReview.name
    detailView.raceReviewTextView.text = raceReview.review
    detailView.dismissButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
    detailView.deleteButton.addTarget(self, action: #selector(deleteRaceReview), for: .touchUpInside)
    
    // only show the delete button if it the reviewerId == current userId 
    detailView.deleteButton.isHidden = editingState == .authorizedForEditing ? false : true
  }
  
  @objc private func dismissView() {
    dismiss(animated: true)
  }
  
  @objc private func deleteRaceReview() {
    showAlert(title: "Confirm Delete", message: "Please confirm that you want to delete your created race review. This action cannot be undone", style: .actionSheet) { (alertController) in
      let deleteAction = UIAlertAction(title: "Confirm Delete", style: .destructive, handler: { (delete) in
        self.executeDeletion()
      })
      alertController.addAction(deleteAction)
      self.present(alertController, animated: true)
    }
  }
  
  private func executeDeletion() {
    DatabaseManager.firebaseDB
      .collection(DatabaseKeys.RaceReviewCollectionKey)
      .document(raceReview.dbReferenceDocumentId).delete { (error) in
        if let error = error {
          self.showAlert(title: "Deleting Error", message: error.localizedDescription)
        } else {
          self.showAlert(title: "", message: "Race Review was deleted successfully",  style: .alert, handler: { (alertController) in
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (alert) in
              self.dismiss(animated: true)
            })
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
          })
        }
    }
  }
}
