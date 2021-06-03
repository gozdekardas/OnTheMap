//
//  LoginRequest.swift
//  OnTheMap
//
//  Created by GOZDE KARDAS on 2.06.2021.
//

import Foundation

struct LoginRequest: Codable {
    let udacity: Udacity
}

struct Udacity: Codable{
    let username: String
    let password: String
}
