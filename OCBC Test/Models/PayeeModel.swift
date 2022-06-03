//
//  PayeeModel.swift
//  OCBC Test
//
//  Created by Kevin Chilmi Rezhaldo on 25/05/22.
//

import Foundation

// MARK: - Welcome
struct Payee: Codable {
    let status: String
    let data: [PayeeData]
}

// MARK: - Datum
struct PayeeData: Codable {
    let id: String
    let name: String
    let accountNo: String
}
