//
//  ProfileViewController.swift
//  RaceReviews
//
//  Created by Alex Paul on 2/12/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

class ProfileViewController: UITableViewController {
  
  @IBOutlet weak var signOutButton: UIButton!
  @IBOutlet weak var emailLabel: UILabel!
  
  private var usersession: UserSession!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // getting instance from AppDelegate
    usersession = (UIApplication.shared.delegate as! AppDelegate).usersession
    
    // set the delegate for sign out
    usersession.usersessionSignOutDelegate = self
    
    // set email label
    if let user = usersession.getCurrentUser() {
      emailLabel.text = user.email ?? "no email found for logged user"
    } else {
      emailLabel.text = "no logged user"
    }
  }
  
  @IBAction func signOutButtonPressed(_ sender: UIButton) {
    usersession.signOut()
  }
  
}

extension ProfileViewController: UserSessionSignOutDelegate {
  func didRecieveSignOutError(_ usersession: UserSession, error: Error) {
    print("didRecieveSignOutError: \(error)")
  }
  
  func didSignOutUser(_ usersession: UserSession) {
    print("didSignOutUser successfully")
    // present the login view controller
    let window = (UIApplication.shared.delegate as! AppDelegate).window
    
    // BUG HERE: "RaceReviewsTab" => "Main"
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
    window?.rootViewController = loginViewController
  }
}
