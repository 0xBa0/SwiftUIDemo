//
//  AppCommand.swift
//  SwiftUILoginDemo
//
//  Created by Zack on 2020/2/17.
//

import Foundation
import Combine

class SubscriptionToken {
    var cancellable: AnyCancellable?
    func remove() { cancellable = nil }
}

extension AnyCancellable {
    func store(in token: SubscriptionToken) {
        token.cancellable = self
    }
}

//MARK: - AppCommand 用于服务器和数据库
protocol AppCommand {
    func execute(in store: Store)
}

struct LoginCommand: AppCommand {
   
    let email: String
    let password: String
    
    func execute(in store: Store) {
                
        if !email.isValidEmail {
            store.dispatch(action: LoginViewAction.emailInvalid(error: .emailError))
        }
        else if !password.isValidPassword {
            store.dispatch(action: LoginViewAction.passwordInvalid(error: .passwordError))
        }
        else {
            let token = SubscriptionToken()
            LoginRequest(email: email, password: password)
                .publisher
                .sink(receiveCompletion: { (complete) in
                    print(complete)
                    if case .failure(let error) = complete {
                        store.dispatch(action: .loginDone(result: .failure(error)))
                    }
                    token.remove()
                }, receiveValue: { (user) in
                    store.dispatch(action: .loginDone(result: .success(user)))
                })
                .store(in: token)
        }
    }
    
}

struct SaveUserCommand: AppCommand {
    let user: AuthenticateUser
    func execute(in store: Store) {
        Repository().saveUser(user: user)
        store.dispatch(action: .checkIsLogin)
    }
}

struct GetUserCommand: AppCommand {
    func execute(in store: Store) {
        let user = Repository().retriveUser()
        store.dispatch(action: .getUser(user: user))
    }
}
struct LogoutCommand: AppCommand {
    func execute(in store: Store) {
        Repository().deleteUser()
    }
}

struct RegistCommand: AppCommand {
    let email: String
    let password: String
    let verifyPassword: String
    
    func execute(in store: Store) {
        
        if !email.isValidEmail {
            store.dispatch(action: RegistViewAction.emailInvalid(error: .emailError))
        }
        else if !password.isValidPassword {
            store.dispatch(action: RegistViewAction.passwordInvalid(error: .passwordError))
        }
        else if verifyPassword != password {
            store.dispatch(action: .differentPassword(error: .differentPasswordError))
        }
        else {
            let token = SubscriptionToken()
            RegistRequest(email: email, password: password)
                .publisher
                .sink(receiveCompletion: { (complete) in
                    print("[RegistRequest]" , complete)
                    if case .failure(let error) = complete {
                        store.dispatch(action: .registDone(result: .failure(error)))
                    }
                    token.remove()
                }, receiveValue: { (userID) in
                    store.dispatch(action: .registDone(result: .success(userID)))
                })
                .store(in: token)
        }
    }
}

struct GobackFromRegistViewCommand: AppCommand {
    func execute(in store: Store) {
        store.dispatch(action: LoginViewAction.gobackFromRegisterView)
    }
}

struct LoadCatsCommand: AppCommand {
    func execute(in store: Store) {
        let token = SubscriptionToken()

        LoadCatsRequest()
        .publisher
        .sink(receiveCompletion: { (complete) in
            print("[LoadCatsCommand]" , complete)
            if case .failure(let error) = complete {
                store.dispatch(action: .getDone(result: .failure(error)))
            }
            token.remove()
        }, receiveValue: { (cats) in
            store.dispatch(action: .getDone(result: .success(cats)))
        })
        .store(in: token)
    }
}
