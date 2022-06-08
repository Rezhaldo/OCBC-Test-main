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
    static let  shareInstance = APIManager()
    
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
}
