//
//  AppState.swift
//  SwiftUILoginDemo
//
//  Created by Zack on 2020/2/17.
//

import Foundation
import Combine

//State Tree：状态树会越来越庞大
//Q: 如何释放不需要了的state？
class AppState {
    @Published var user: AuthenticateUser?
    var isLogin: AnyPublisher<Bool, Never> {
        return $user.map { $0 != nil }.eraseToAnyPublisher()
    }
    
    var loginViewState = AppState.LoginViewState()
    var registViewState = AppState.RegistViewState()
    
    var homeViewState = AppState.HomeViewState()
}
