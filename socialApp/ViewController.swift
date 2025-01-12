//
//  ViewController.swift
//  socialApp
//
//  Created by Cüneyt Aykaç on 7.01.2025.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {

   

    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func signInClicked(_ sender: Any) {
        performSegue(withIdentifier:"toFeedVC", sender: nil)
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        // Kullanıcı bilgilerini kontrol et
              guard let email = emailField.text, !email.isEmpty,
                    let password = passwordField.text, !password.isEmpty else {
                  showAlert(titleInput: "Hata", messageInput: "Lütfen tüm alanları doldurunuz.")
                  return
              }

              // Firebase ile kullanıcı oluşturma
              Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
                  guard let self = self else { return }

                  if let error = error {
                      self.handleFirebaseError(error)
                  } else {
                      // Kullanıcı başarıyla oluşturuldu, diğer sayfaya geçiş yap
                      self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                  }
              }
      
    }
    
    // Firebase hata yönetimi
    private func handleFirebaseError(_ error: Error) {
        if let authError = AuthErrorCode(rawValue: error._code) {
            switch authError {
            case .emailAlreadyInUse:
                showAlert(titleInput: "Hata", messageInput: "Bu e-posta zaten kullanılıyor.")
            case .weakPassword:
                showAlert(titleInput: "Hata", messageInput: "Şifre çok zayıf. Lütfen daha güçlü bir şifre deneyin.")
            case .invalidEmail:
                showAlert(titleInput: "Hata", messageInput: "Geçersiz e-posta formatı.")
            default:
                showAlert(titleInput: "Hata", messageInput: error.localizedDescription)
            }
        } else {
            showAlert(titleInput: "Hata", messageInput: "Bilinmeyen bir hata oluştu. Lütfen tekrar deneyin.")
        }
    }
    func showAlert(titleInput:String,messageInput:String?){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}

