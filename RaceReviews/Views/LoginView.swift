//
//  LoginView.swift
//  RaceReviews
//
//  Created by Alex Paul on 2/11/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

// states of login
enum AccountLoginState {
  case newAccount
  case existingAccount
}

// delegate for the LoginView
protocol LoginViewDelegate: AnyObject {
  func didSelectLoginButton(_ loginView: LoginView, accountLoginState: AccountLoginState)
}

class LoginView: UIView {
  
  @IBOutlet var contentView: UIView!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextFiled: UITextField!
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var accountMessageLabel: UILabel!
  
  // gesture to handle accepting tapping on the accountMessageLabel
  private var tapGesture: UITapGestureRecognizer!
  
  // setting default account state
  private var accountLoginState = AccountLoginState.newAccount
  
  public weak var delegate: LoginViewDelegate?
  
  // coming from programmatic ui code
  override init(frame: CGRect) {
    super.init(frame: UIScreen.main.bounds)
    commonInit()
  }
  
  // coming from storyboard or nib/.xib file
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  // bridging helper methods
  private func commonInit() {
    // load the nib/.xib file
    Bundle.main.loadNibNamed("LoginView", owner: self, options: nil)
    addSubview(contentView)
    // content view takes size of self.bounds
    contentView.frame = bounds
    contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    // setup button action
    loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
    
    // setup message label actions
    // setup tap gesture recognizer
    
    // UILabel and UIImageView by default isUserInteractionEnabled is false, thus not allowing for gesture recognition by the user
    accountMessageLabel.isUserInteractionEnabled = true
    tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(gestureRecognizer:)))
    accountMessageLabel.addGestureRecognizer(tapGesture)
  }
  
  @objc private func loginButtonPressed() {
    delegate?.didSelectLoginButton(self, accountLoginState: accountLoginState)
  }
  
  @objc private func handleTap(gestureRecognizer: UITapGestureRecognizer) {
    accountLoginState = accountLoginState == .newAccount ? .existingAccount : .newAccount
    switch accountLoginState {
    case .newAccount:
      loginButton.setTitle("Create", for: .normal)
      accountMessageLabel.text = "Login into your account"
    case .existingAccount:
      loginButton.setTitle("Login", for: .normal)
      accountMessageLabel.text = "New User? Create an account"
    }
  }
}
