//
//  FeedViewController.swift
//  socialApp
//
//  Created by Cüneyt Aykaç on 11.01.2025.
//

import UIKit
import FirebaseFirestore

class FeedViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var response: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromFirestore()

        // Do any additional setup after loading the view.
    }
    
    
    func getDataFromFirestore(){
        let db = Firestore.firestore()
        db.collection("Post")
          .addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
              print("Error fetching document: \(error!)")
              return
            }
              self.response.removeAll() // Listeyi sıfırla
            if document.isEmpty{
                  print("Document data was empty.")
            }else{
                for d in document.documents{
                    let data = d.data()
                    if let post = Post(dictionary: data) {
                            self.response.append(post)
                    }
                   
                }
            }
             
              DispatchQueue.main.async {
                             self.tableView.reloadData()
                         }
             
            
          }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.response.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        
        cell.likeCount.text = "\(self.response[indexPath.row].likes)"
        cell.username.text = "\(self.response[indexPath.row].createdBy)"
        cell.userComment.text = "\(self.response[indexPath.row].postComment)"
        cell.userImage.image = UIImage(systemName: "photo")
        
        return cell;
    }
    
    
    
    

}
