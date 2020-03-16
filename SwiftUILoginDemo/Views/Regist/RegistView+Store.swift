//
//  RegistView+Store.swift
//  SwiftUILoginDemo
//
//  Created by Zack on 2020/2/19.
//

import Foundation

extension AppState {
    
    struct RegistViewState {
        var email: String = ""
        var password: String = ""
        var verifyPassword: String = ""
        
        var isRequesting: Bool = false
        var registError: AppError?
    }
    
}

enum RegistViewAction {
    case regist(email: String, password: String, verifyPassword: String)
    case emailInvalid(error: AppError)
    case passwordInvalid(error: AppError)
    case differentPassword(error: AppError)
    case registDone(result: Result<String, AppError>)
}

extension Store {
    func dispatch(action: RegistViewAction) {
        let (nextLoginViewState, command) = Store.reduce(state.registViewState, action)
        state.registViewState = nextLoginViewState
        didUpdateState(next: state)
        command?.execute(in: self)
    }
    
    static func reduce(_ state: AppState.RegistViewState,
                       _ action: RegistViewAction) -> (AppState.RegistViewState, AppCommand?) {
        var nextRegistViewState = state
        var command: AppCommand?
        
        switch action {
        case .regist(let email, let password, let verifyPassword):
            guard !nextRegistViewState.isRequesting else { break }
            nextRegistViewState.isRequesting = true

            command = RegistCommand(email: email, password: password, verifyPassword: verifyPassword)
        case .emailInvalid(let error):
            nextRegistViewState.isRequesting = false
            nextRegistViewState.registError = error
        case .passwordInvalid(let error):
            nextRegistViewState.isRequesting = false
            nextRegistViewState.registError = error
        case .differentPassword(let error):
            nextRegistViewState.isRequesting = false
            nextRegistViewState.registError = error
        case .registDone(let result):
            nextRegistViewState.isRequesting = false
            switch result {
            case .success(_): 
                command = GobackFromRegistViewCommand()
            case .failure(let error):
                nextRegistViewState.registError = error
            }
        }
        return (nextRegistViewState, command)
    }

}
