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
        
        if let username = emailField.text , let password = passwordField.text{
            if username == "" || password == ""{
                self.showAlert(titleInput: "ERROR!", messageInput: "ALANLARI DOLDURUNUZ")
            }
            Auth.auth().createUser(withEmail: username, password: password) { (data,error) in
                
                if error != nil {
                    self.showAlert(titleInput: "ERROR!", messageInput: error?.localizedDescription)
                    
                }else{
                    self.performSegue(withIdentifier:"toFeedVC", sender: nil)
                }
                    
            }
        }else{
            self.showAlert(titleInput: "ERROR!", messageInput: "HATA")
        }
        
      
    }
    
    func showAlert(titleInput:String,messageInput:String?){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}

