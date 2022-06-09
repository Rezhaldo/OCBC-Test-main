//
//  APIManager.swift
//  OCBC Test
//
//  Created by USER-MAC-GLIT-008 on 08/06/22.
//

import Foundation
import Alamofire

enum APIErros: Error {
    case custom(message: String)
}

typealias Handler = (Swift.Result<Any?, APIErros>) -> Void

class APIManager {
    var username: String = ""
    static let  shareInstance = APIManager()
    let userToken = UserDefaults.standard.string(forKey: "user_token") ?? ""
    
    
    func callingRegisterAPI(register : RegisterRequest, completion: @escaping Handler) {
        let headers = HTTPHeaders(["Content-Type":"application/json", "Accept":"application/json"])
        
        AF.request(register_url!, method: .post, parameters: register, encoder: JSONParameterEncoder.default, headers: headers).response (completionHandler: { response in
            guard let data = response.data else { return }
            
            do {
                let decoder = JSONDecoder()
                let registerResponse =
                try decoder.decode(RegisterResponse.self, from: data)
                print(registerResponse)
                
                if response.response?.statusCode == 200{
                    completion(.success(registerResponse))
                }else {
                    completion(.failure(.custom(message: "Fail to connect, try again.")))
                }
                
            } catch let error {
                print("Error Request: \(error.localizedDescription)")
            }
        })
    
    }
    
    func callingLoginAPI(login : LoginRequest, completion: @escaping Handler) {
        let headers = HTTPHeaders(["Content-Type":"application/json", "Accept":"application/json"])

        
        AF.request(login_url!, method: .post, parameters: login, encoder: JSONParameterEncoder.default, headers: headers).response (completionHandler: { response in
            guard let data = response.data else { return }

            do {

                let decoder = JSONDecoder()
                let loginResponse =
                try decoder.decode(LoginResponse.self, from: data)
                print("succes: \(loginResponse)")
                
                if response.response?.statusCode == 200{
                    completion(.success(loginResponse))
                }else {
                    completion(.failure(.custom(message: "Fail to connect, try again.")))
                }
                
            } catch let error {
                print("Error Request: \(error.localizedDescription)")
            }
        })

    }
    
    func callingBalanceAPI(completionHandeler: @escaping Handler) {
        let headers = HTTPHeaders(["Content-Type":"application/json", "Accept":"application/json", "Authorization": userToken])
        
        AF.request(balance_url!, method: .get, headers: headers).response (completionHandler: { response in
            guard let data = response.data else { return }
            
            
            do {
                

                let decoder = JSONDecoder()
                let balanceResponse =
                try decoder.decode(BalanceResponse.self, from: data)
                
                if response.response?.statusCode == 200{
                    completionHandeler(.success(balanceResponse))
                }else {
                    completionHandeler(.failure(.custom(message: "Fail to connect, try again.")))
                }
                
//                if response.response?.statusCode == 401{
//                    completionHandeler(.success(balanceResponse.error))
//                }else {
//                    completionHandeler(.failure(.custom(message: "NIL")))
//                }

               
            } catch let error {
                print("Error Request: \(error.localizedDescription)")
            }
        })

    }
    
}
