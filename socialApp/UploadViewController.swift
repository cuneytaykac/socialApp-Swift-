//
//  UploadViewController.swift
//  socialApp
//
//  Created by Cüneyt Aykaç on 11.01.2025.
//

import UIKit
import FirebaseStorage
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class UploadViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var contentField: UITextField!
    private var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActivityIndicator()
    }
    // MARK: - UI Setup
        private func setupUI() {
            contentField.delegate = self
            setupImageViewGesture()
        }
    
    private func setupActivityIndicator() {
           activityIndicator = UIActivityIndicatorView(style: .large)
           activityIndicator.center = view.center
           activityIndicator.hidesWhenStopped = true
           activityIndicator.color = .gray
           view.addSubview(activityIndicator)
       }
    
    private func setupImageViewGesture() {
          let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleImageViewTap))
          imageView.isUserInteractionEnabled = true
          imageView.addGestureRecognizer(tapGestureRecognizer)
      }
    // MARK: - Actions
       @objc private func handleImageViewTap() {
           presentImagePicker()
       }
       
    private func presentImagePicker() {
            guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
                self.showAlert(titleInput: "Hata",messageInput : "Fotoğraf galerisine erişilemiyor.")
                return
            }
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true)
        }
        
        

    
    @IBAction func saveButton(_ sender: Any) {
        guard let imageData = imageView.image?.jpegData(compressionQuality: 0.5) else {
                   showAlert(titleInput: "Hata", messageInput: "Bir resim seçmelisiniz.")
                   return
               }
               
               toggleLoading(true)
               
               let storage = Storage.storage()
               let mediaFolder = storage.reference().child("media")
               let imageRef = mediaFolder.child("\(UUID().uuidString).jpg")
               
               imageRef.putData(imageData, metadata: nil) { [weak self] metadata, error in
                   guard let self = self else { return }
                   
                   if let error = error {
                       self.toggleLoading(false)
                       self.showAlert(titleInput: "Upload Error", messageInput: error.localizedDescription)
                       return
                   }
                   
                   imageRef.downloadURL { url, error in
                       if let error = error {
                           self.toggleLoading(false)
                           self.showAlert(titleInput: "Download Error", messageInput: error.localizedDescription)
                           return
                       }
                       
                       guard let imageUrl = url?.absoluteString else {
                           self.toggleLoading(false)
                           self.showAlert(titleInput: "Hata", messageInput: "Resim URL'si alınamadı.")
                           return
                       }
                       
                       self.saveToDatabase(imageUrl: imageUrl)
                   }
               }
            
    }
    private func saveToDatabase(imageUrl: String) {
           let db = Firestore.firestore()
           
           let sendData: [String: Any] = [
               "imageUrl": imageUrl,
               "createdBy": Auth.auth().currentUser?.email ?? "Unknown",
               "postComment": contentField.text ?? "No comment",
               "date": FieldValue.serverTimestamp(),
               "likes": 0
           ]
           
           db.collection("Post").addDocument(data: sendData) { [weak self] error in
               guard let self = self else { return }
               
               self.toggleLoading(false)
               
               if let error = error {
                   self.showAlert(titleInput: "Error", messageInput: error.localizedDescription)
               } else {
                   self.resetUI()
                   self.tabBarController?.selectedIndex = 0
               }
           }
       }
    private func resetUI() {
           imageView.image = UIImage(systemName: "photo.badge.plus.fill")
           contentField.text = ""
       }

       // MARK: - Loading State
       private func toggleLoading(_ isLoading: Bool) {
           if isLoading {
               activityIndicator.startAnimating()
               view.isUserInteractionEnabled = false
           } else {
               activityIndicator.stopAnimating()
               view.isUserInteractionEnabled = true
           }
       }
    
   

}
// MARK: - UITextFieldDelegate
extension UploadViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension UploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
            imageView.image = selectedImage
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

