//
//  Repository.swift
//  SwiftUILoginDemo
//
//  Created by Zack on 2020/2/17.
//

import Foundation

fileprivate let userNameKey = "com.wesoft.user.name.key"
fileprivate let userTokenKey = "com.wesoft.user.token.key"

struct Repository {
    
    func saveUser(user: AuthenticateUser) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(user.name, forKey: userNameKey)
        userDefaults.set(user.userID, forKey: userTokenKey)
        userDefaults.synchronize()
    }
    
    func deleteUser() {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: userNameKey)
        userDefaults.removeObject(forKey: userTokenKey)
        userDefaults.synchronize()
    }
    
    func retriveUser() -> AuthenticateUser? {
        let userDefaults = UserDefaults.standard
        
        guard let name = userDefaults.string(forKey: userNameKey),
            let token = userDefaults.string(forKey: userTokenKey) else {
                return nil
        }
        return AuthenticateUser(name: name, userID: token)
    }
    
}
