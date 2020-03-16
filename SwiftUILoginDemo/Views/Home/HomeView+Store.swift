//
//  Home+Store.swift
//  SwiftUILoginDemo
//
//  Created by Zack on 2020/2/20.
//

import Foundation

extension AppState {
    struct HomeViewState {
        var cats = [Cat]()
        var isRequesting: Bool = false
        var loginError: AppError?
    }
}

enum HomeViewAction {
    case getCats
    case getDone(result: Result<[Cat], AppError>)
}

extension Store {
    func dispatch(action: HomeViewAction) {
        let (nextHomeViewState, command) = Store.reduce(state.homeViewState, action)
        state.homeViewState = nextHomeViewState
        didUpdateState(next: state)
        command?.execute(in: self)
    }
    
    static func reduce(_ state: AppState.HomeViewState,
                       _ action: HomeViewAction) -> (AppState.HomeViewState, AppCommand?) {
        var nextState = state
        var command: AppCommand?
        
        switch action {
        case .getCats:
            command = LoadCatsCommand()
        case .getDone(let result):
            nextState.isRequesting = false
            switch result {
            case .success(let cats):
                nextState.cats = cats
            case .failure(let error):
                nextState.loginError = error
            }
        }
        return (nextState, command)
    }

}
