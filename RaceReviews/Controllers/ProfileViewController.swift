//
//  ProfileViewController.swift
//  RaceReviews
//
//  Created by Alex Paul on 2/12/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth

class ProfileViewController: UITableViewController {
  
  @IBOutlet weak var profileImageButton: UIButton!
  @IBOutlet weak var signOutButton: UIButton!
  @IBOutlet weak var emailLabel: UILabel!
  
  private var usersession: UserSession!
  private var storageManager: StorageManager!
  private lazy var imagePickerController: UIImagePickerController = {
    let ip = UIImagePickerController()
    ip.allowsEditing = true
    ip.delegate = self
    return ip
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // getting instance from AppDelegate
    usersession = (UIApplication.shared.delegate as! AppDelegate).usersession
    storageManager = (UIApplication.shared.delegate as! AppDelegate).storageManager

    
    // set the delegate for sign out
    usersession.usersessionSignOutDelegate = self
    
    storageManager.delegate = self
    
    // set email label
    guard let user = usersession.getCurrentUser() else {
      emailLabel.text = "no logged user"
      return
    }
    emailLabel.text = user.email ?? "no email found for logged user"
    
    guard let photoURL = user.photoURL else {
      print("no photoURL")
      return
    }
    if let image = ImageCache.shared.fetchImageFromCache(urlString: photoURL.absoluteString) {
      profileImageButton.setImage(image, for: .normal)
    } else {
      ImageCache.shared.fetchImageFromNetwork(urlString: photoURL.absoluteString) { (appError, image) in
        if let appError = appError {
          self.showAlert(title: "Fetching Image Error", message: appError.errorMessage())
        } else if let image = image {
          self.profileImageButton.setImage(image, for: .normal)
        }
      }
    }
  }
  
  @IBAction func signOutButtonPressed(_ sender: UIButton) {
    usersession.signOut()
  }
  
  @IBAction func showPhotoActionSheet(_ button: UIButton) {
    showAlert(title: nil, message: nil, style: .actionSheet) { (alertController) in
      let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
        self.imagePickerController.sourceType = .camera
        self.showImagePickerController()
      }
      let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) { (action) in
        self.imagePickerController.sourceType = .photoLibrary
        self.showImagePickerController()
      }
      if UIImagePickerController.isSourceTypeAvailable(.camera) {
        alertController.addAction(cameraAction)
      }
      alertController.addAction(photoLibrary)
      alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
      self.present(alertController, animated: true)
    }
  }
  
  private func showImagePickerController() {
    present(imagePickerController, animated: true, completion: nil)
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

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
      showAlert(title: "Error with Image", message: "Try Again")
      return
    }
    profileImageButton.setImage(originalImage, for: .normal)
        
    // TODO: both the authenticated user's photoURL and database user's imageURL
    guard let imageData = originalImage.jpegData(compressionQuality: 0.5) else {
      print("failed to create data from image")
      return
    }
    storageManager.postImage(withData: imageData)
    
    dismiss(animated: true)
  }
}

extension ProfileViewController: StorageManagerDelegate {
  func didFetchImage(_ storageManager: StorageManager, imageURL: URL) {
    usersession.updateUser(displayName: nil, photoURL: imageURL)
  }
}
