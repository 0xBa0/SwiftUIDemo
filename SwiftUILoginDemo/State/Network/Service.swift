//
//  Service.swift
//  SwiftUILoginDemo
//
//  Created by Zack on 2020/2/17.
//

import Foundation

//"http://localhost:3000/api/" 讲localhost填写成本机的IP
public let BaseURL = "http://172.16.4.61:3000/api/"

extension URLRequest {
    
    static func GET(_ url: String, parameters: [String: String]) -> URLRequest {
        let queries = parameters
            .map { $0.key + "="  + ($0.value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") }
            .joined(separator: "&")
        var request = URLRequest(url: URL(string: url + "?" + queries)!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Accept")
        
        return request
    }
    
    static func POST(_ url: String, parameters: Dictionary<AnyHashable, AnyHashable>) -> URLRequest {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Accept")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        return request
    }
    
}
