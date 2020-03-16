//
//  LoginRequest.swift
//  SwiftUILoginDemo
//
//  Created by Zack on 2020/2/17.
//

import Combine
import Foundation

struct LoginRequest {

    let email: String
    let password: String
    
    var publisher: AnyPublisher<AuthenticateUser, AppError> {
        
        let parameters = ["email": email, "password": password]
        let request = URLRequest.POST(BaseURL+"emailSignin",
                                      parameters: parameters)
        
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .mapError { AppError.networkingFailed($0) } 
            .map { (r) -> Data in
                
                #if DEBUG
                var strJson: String = ""
                if let str = String(data: r.data, encoding: .utf8){
                    strJson = str
                }
                print(strJson)
                #endif
                
                return r.data
            }
            .decode(type: LoginResponse.self, decoder: JSONDecoder())
            .tryMap { try $0.createModel(email: self.email) }
            .mapError { $0 as? AppError ?? AppError.decodingError($0) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

struct LoginResponse: Decodable {

    let code: Int
    let message: String?
    let data: DataField?
    
    struct DataField: Decodable {
        let userId: String
    }

    func createModel(email: String) throws -> AuthenticateUser {
        if code == 0 {
            return AuthenticateUser(name: email, userID: data?.userId ?? "")
        }
        else {
            throw createError()
        }
    }
    
    func createError() -> AppError {
        return AppError.serverError(code: code, message: message ?? "")
    }
}


