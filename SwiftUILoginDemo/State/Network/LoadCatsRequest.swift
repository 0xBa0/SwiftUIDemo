//
//  LoadCatsRequest.swift
//  SwiftUILoginDemo
//
//  Created by Zack on 2020/2/20.
//

import Foundation
import Combine

//public API
//https://documenter.getpostman.com/view/4016432/RWToRJCq?version=latest#3003b20d-bc53-4e4b-bec7-ec23f8c57183
struct LoadCatsRequest {
    
    var publisher: AnyPublisher<[Cat], AppError> {
        
        var request = URLRequest.GET("https://api.thecatapi.com/v1/images/search", parameters: ["limit": "10"])
        request.addValue("9564d8ec-e05a-4677-8cb0-0230e0b051b3", forHTTPHeaderField: "x-api-key")
        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError { AppError.networkingFailed($0) }
            .map { $0.data }
            .decode(type: [CatsResponse].self, decoder: JSONDecoder())
            .map { $0.map { $0.createModel() } }
            .mapError { $0 as? AppError ?? AppError.decodingError($0) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}

struct CatsResponse: Decodable {
    let id: String
    let url: String
    
    func createModel() -> Cat {
        return Cat(id: id, imageURL: url)
    }
}
