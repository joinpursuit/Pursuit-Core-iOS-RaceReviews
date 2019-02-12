//
//  ViewController.swift
//  RaceReviews
//
//  Created by Alex Paul on 2/11/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var loginView: LoginView!

  override func viewDidLoad() {
    super.viewDidLoad()
    loginView.delegate = self
  }
}

extension ViewController: LoginViewDelegate {
  func didSelectLoginButton(_ loginView: LoginView, accountLoginState: AccountLoginState) {
    print("user account state is \(accountLoginState)")
  }
}

