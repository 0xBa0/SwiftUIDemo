//
//  RegistRequest.swift
//  SwiftUILoginDemo
//
//  Created by Zack on 2020/2/19.
//

import Foundation
import Combine

struct RegistRequest {
    let email: String
    let password: String
    
    var publisher: AnyPublisher<String, AppError> {
        
        let request = URLRequest.POST(BaseURL+"emailSignup",
                                      parameters: ["email": email, "password": password])
            
        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError { AppError.networkingFailed($0) }
            .map { $0.data }
            .decode(type: RegistResponse.self, decoder: JSONDecoder())
            .tryMap { try $0.createModel() }
            .mapError { $0 as? AppError ?? AppError.decodingError($0) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

struct RegistResponse: Decodable {
    let code: Int
    let message: String?
    let data: DataField?
    
    struct DataField: Decodable {
        let userId: String
    }
    
    func createModel() throws -> String {
           if code == 0 {
            return data?.userId ?? ""
           }
           else {
               throw createError()
           }
       }
       
       func createError() -> AppError {
           return AppError.serverError(code: code, message: message ?? "")
       }
}
