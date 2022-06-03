//
//  RegisterModel.swift
//  OCBC Test
//
//  Created by Kevin Chilmi Rezhaldo on 23/05/22.
//

import Foundation

struct RegisterRequest: Codable {
    let username: String
    let password: String
}

struct RegisterResponse: Codable {
    let status: String
    let error: String?
    let token: String?
}
