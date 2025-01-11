//
//  ViewController.swift
//  socialApp
//
//  Created by Cüneyt Aykaç on 7.01.2025.
//

import UIKit

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
    }
}

