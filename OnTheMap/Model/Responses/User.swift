//
//  User.swift
//  OnTheMap
//
//  Created by GOZDE KARDAS on 3.06.2021.
//

struct User: Codable {
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
