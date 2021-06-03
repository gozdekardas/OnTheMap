//
//  Location.swift
//  OnTheMap
//
//  Created by GOZDE KARDAS on 2.06.2021.
//


struct Location: Codable{
    let firstName: String
    let lastName: String
    let longitude: Double
    let latitude: Double
    let mapString:String
    let mediaURL: String
    let uniqueKey: String
    
    enum CodingKeys: String, CodingKey {
        case firstName
        case lastName
        case longitude
        case latitude
        case mapString
        case mediaURL
        case uniqueKey
    }
}
