//
//  LoginModel.swift
//  OCBC Test
//
//  Created by Kevin Chilmi Rezhaldo on 22/05/22.
//

import Foundation

struct LoginRequest: Codable {
    let username: String
    let password: String
}

struct LoginResponse: Codable {
    let status: String
    let token: String
    let username: String
    let accountNo: String
}
