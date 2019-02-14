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
    showAlert(title: "Sign Out Error", message: error.localizedDescription)
  }
  
  func didSignOutUser(_ usersession: UserSession) {
    presentLoginViewController()
  }
  
  private func presentLoginViewController() {
    let window = (UIApplication.shared.delegate as! AppDelegate).window
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
    window?.rootViewController = loginViewController
  }
}
