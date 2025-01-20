//
//  postModel.swift
//  socialApp
//
//  Created by Cüneyt Aykaç on 20.01.2025.
//

import Foundation
import FirebaseCore

struct Post: Codable {
    let postComment: String
    let date: Date
    let imageUrl: URL
    let createdBy: String
    let likes: Int
    
    // Firebase'den gelen veriyi işlemek için init
    init?(dictionary: [String: Any]) {
        guard
            let postComment = dictionary["postComment"] as? String,
            let timestamp = dictionary["date"] as? Timestamp,
            let imageUrlString = dictionary["imageUrl"] as? String,
            let imageUrl = URL(string: imageUrlString),
            let createdBy = dictionary["createdBy"] as? String,
            let likes = dictionary["likes"] as? Int
        else {
            return nil
        }
        
        self.postComment = postComment
        self.date = timestamp.dateValue()
        self.imageUrl = imageUrl
        self.createdBy = createdBy
        self.likes = likes
    }
}

