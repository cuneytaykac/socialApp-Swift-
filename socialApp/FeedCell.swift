//
//  FeedCell.swift
//  socialApp
//
//  Created by Cüneyt Aykaç on 20.01.2025.
//

import UIKit

class FeedCell: UITableViewCell {
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userComment: UILabel!
    
    @IBOutlet weak var likeCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func likeButton(_ sender: Any) {
    }
    
}
