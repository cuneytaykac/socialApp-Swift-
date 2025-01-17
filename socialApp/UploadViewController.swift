//
//  UploadViewController.swift
//  socialApp
//
//  Created by Cüneyt Aykaç on 11.01.2025.
//

import UIKit

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

