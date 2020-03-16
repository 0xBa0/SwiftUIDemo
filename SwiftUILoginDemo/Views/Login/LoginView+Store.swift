//
//  LoginView+Store.swift
//  SwiftUILoginDemo
//
//  Created by Zack on 2020/2/17.
//

import Foundation

extension AppState {
    struct LoginViewState {
        var email: String = ""
        var password: String = ""
        var showPassword: Bool = false
        var isRequesting: Bool = false
        var loginError: AppError?
        
        var gotoRegisterView: Bool = false
    }
}

enum LoginViewAction {
    case showHidePassword
    case login(email: String, password: String)
    case emailInvalid(error: AppError)
    case passwordInvalid(error: AppError)
    case loginDone(result: Result<AuthenticateUser, AppError>)
    case gobackFromRegisterView
}

extension Store {
    func dispatch(action: LoginViewAction) {
        let (nextLoginViewState, command) = Store.reduce(state.loginViewState, action)
        state.loginViewState = nextLoginViewState
        didUpdateState(next: state)
        command?.execute(in: self)
    }
    
    static func reduce(_ state: AppState.LoginViewState,
                       _ action: LoginViewAction) -> (AppState.LoginViewState, AppCommand?) {
        var nextLoginViewState = state
        var command: AppCommand?
        
        switch action {
        case .showHidePassword:
            nextLoginViewState.showPassword = !nextLoginViewState.showPassword
        case .login(let email, let password):
            guard !nextLoginViewState.isRequesting else { break }
            nextLoginViewState.isRequesting = true
            command = LoginCommand(email: email, password: password)
        case .emailInvalid(let error):
            nextLoginViewState.isRequesting = false
            nextLoginViewState.loginError = error
        case .passwordInvalid(let error):
            nextLoginViewState.isRequesting = false
            nextLoginViewState.loginError = error
        case .loginDone(let result):
            nextLoginViewState.isRequesting = false
            switch result {
            case .success(let user):
                command = SaveUserCommand(user: user)
            case .failure(let error):
                nextLoginViewState.loginError = error
            }
        case .gobackFromRegisterView:
            nextLoginViewState.gotoRegisterView = false
        }
        return (nextLoginViewState, command)
    }

}
