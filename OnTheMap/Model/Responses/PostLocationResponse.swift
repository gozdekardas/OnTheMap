//
//  PostLocationResponse.swift
//  OnTheMap
//
//  Created by GOZDE KARDAS on 3.06.2021.
//

struct PostLocationResponse: Codable {
    let createdAt: Int
    let objectId: String
    
    enum CodingKeys: String, CodingKey {
        case createdAt
        case objectId
    }
}
