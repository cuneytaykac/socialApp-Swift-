//
//  FeedViewController.swift
//  socialApp
//
//  Created by Cüneyt Aykaç on 11.01.2025.
//

import UIKit

class FeedViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        
        cell.likeCount.text = "0"
        cell.username.text = "username"
        cell.userComment.text = "comment"
        cell.userImage.image = UIImage(systemName: "photo")
        
        return cell;
    }
    
    

}
