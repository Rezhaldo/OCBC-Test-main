//
//  OCBC_TestTests.swift
//  OCBC TestTests
//
//  Created by Kevin Chilmi Rezhaldo on 19/05/22.
//

import XCTest
import Alamofire
@testable import OCBC_Test

class OCBC_TestTests: XCTestCase {
    
    func isValidLogin() throws {
        let loginRequest = LoginRequest(username: "test", password:  "asdasd")
        let header = HTTPHeaders(["Content-Type":"application/json", "Accept":"application/json"])
        let loginUrl = URL(string: "https://green-thumb-64168.uc.r.appspot.com/login")
        
        AF.request(loginUrl!, method: .post, parameters: loginRequest, encoder: JSONParameterEncoder.default, headers: header).response(completionHandler: { response in

            guard let data = response.data else { return }
            
            do {
                let decoder = JSONDecoder()
                let loginResponse = try decoder.decode(LoginResponse.self, from: data)
                print("Success request: \(loginResponse)")
            } catch let error {
                print("Error request: \(error.localizedDescription)")
            }
        })
    }
}
