//
//  UserDataResponse.swift
//  OnTheMap
//
//  Created by GOZDE KARDAS on 3.06.2021.
//

struct UserDataResponse: Codable {
    
    let user: UserModel
    
    enum CodingKeys: String, CodingKey {
        
        case user
        
    }
    
}

struct UserModel: Codable {
    
    var firstName: String
    
    var lastName: String
    
    var uniqueKey: String
    
    enum CodingKeys: String, CodingKey {
        
        case firstName = "first_name"
        
        case lastName = "last_name"
        
        case uniqueKey = "key"
        
    }
    
}
