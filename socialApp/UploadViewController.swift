//
//  UploadViewController.swift
//  socialApp
//
//  Created by Cüneyt Aykaç on 11.01.2025.
//

import UIKit
import FirebaseStorage

class UploadViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var contentField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Delegate atamasını yapıyoruz
        setupUI()
    }
    // MARK: - UI Setup
       private func setupUI() {
           // UITextField delegate ataması
           contentField.delegate = self
           
           // UIImageView'e tıklama özelliği ekleme
           let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleImageViewTap))
           imageView.isUserInteractionEnabled = true
           imageView.addGestureRecognizer(tapGestureRecognizer)
       }
    // MARK: - Actions
       @objc private func handleImageViewTap() {
           presentImagePicker()
       }
       
    // MARK: - Helper Methods
        private func presentImagePicker() {
            guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
                showAlert(title: "Hata", message: "Fotoğraf galerisine erişilemiyor.")
                return
            }
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true)
        }
        
        private func showAlert(title: String, message: String) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Tamam", style: .default)
            alertController.addAction(okAction)
            present(alertController, animated: true)
        }

    
    @IBAction func saveButton(_ sender: Any) {
        // Get a reference to the storage service using the default Firebase App
        let storage = Storage.storage()

        // Create a storage reference from our storage service
        let storageRef = storage.reference()
        
        let mediaFolder = storageRef.child("media")
        
        if let imageData = imageView.image?.jpegData(compressionQuality: 0.5){
            let imageRef = mediaFolder.child("\(UUID().uuidString).jpg")
            
            imageRef.putData(imageData, metadata: nil) { (metadata, error) in
                if let error = error {
                    print("Error uploading image: \(error)")
                    
                    self.showAlert(titleInput: "Upload Error", messageInput:"\(error.localizedDescription)")
                    return
                }
                else{
                    imageRef.downloadURL{ (url,error) in
                        if let error = error {
                            self.showAlert(titleInput: "Dowland Error", messageInput:"\(error.localizedDescription)")
                          
                            return
                        }else{
                            let imageUrl = url?.absoluteString
                            print("imageUrl: \(imageUrl)")
                        }
                        
                        
                    }
                }
              
            }
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

