//
//  BalanceModel.swift
//  OCBC Test
//
//  Created by Kevin Chilmi Rezhaldo on 22/05/22.
//

import Foundation

struct BalanceResponse: Codable {
    let status: String
    let accountNo: String
    let balance: Int
}

