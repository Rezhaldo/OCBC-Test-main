//
//  TransactionModel.swift
//  OCBC Test
//
//  Created by Kevin Chilmi Rezhaldo on 23/05/22.
//

import Foundation


// MARK: - Welcome
struct TransactionResponse: Codable {
    let status: String?
    let error: String?
    let data: [TransactionData?]
}

// MARK: - Datum
struct TransactionData: Codable {
    let transactionID: String?
    let amount: Double?
    let transactionDate: String?
    let datumDescription: String?
    let transactionType: String?
    let receipient: Receipient?
    
    enum CodingKeys: String, CodingKey {
        case transactionID = "transactionId"
        case amount, transactionDate
        case datumDescription = "description"
        case transactionType, receipient
    }

}

// MARK: - Receipient
struct Receipient: Codable {
    let accountNo: String?
    let accountHolder: String?
}

