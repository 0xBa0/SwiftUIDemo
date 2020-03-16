//
//  AppStore.swift
//  SwiftUILoginDemo
//
//  Created by Zack on 2020/2/17.
//

import Foundation
import Combine

//存储状态树，处理派发，更新状态树
class Store: ObservableObject {
    
    static var shared = Store()
    @Published var state = AppState()

    init() {
        dispatch(action: .checkIsLogin)
    }
    
    //action事件的派发，获取更新后的state，以及执行command
    func dispatch(action: AppAction) {
        let (nextState, command) = Store.reduce(state, action)
        state = nextState
        command?.execute(in: self)
    }
    
    //根据action事件，处理state
    static func reduce(_ state: AppState, _ action: AppAction) -> (AppState, AppCommand?) {

        let nextState = state
        var command: AppCommand?

        switch action {
        case .checkIsLogin:
            command = GetUserCommand()
        case .getUser(let user):
            nextState.user = user
        case .logout:
            nextState.user = nil
            command = LogoutCommand()
        }
        
        return (nextState, command)
    }
    
    func didUpdateState(next state: AppState) {
        self.state = state
    }
}

enum AppAction {
    case checkIsLogin
    case getUser(user: AuthenticateUser?)
    case logout
}









