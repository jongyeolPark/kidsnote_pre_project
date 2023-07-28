//
//  IntroViewReactor.swift
//  KIDS_NOTE_PRE
//
//  Created by 박종열 on 2023/07/27.
//

import Foundation
import ReactorKit
import FirebaseAuth
import GoogleSignIn
import RxRelay

class IntroViewReactor: Reactor {
    
    var initialState: State
    
    private let authService: AuthServiceProtocol
    
    init(authService: AuthServiceProtocol) {
        self.authService = authService
        initialState = State(loading: false, requireSignIn: false, user: nil)
    }
    
    enum Action {
        case checkSign
        case requestAuth(GIDSignInResult)
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setRequireSignIn(Bool)
        case setUser(FirebaseAuth.User?)
    }
    
    struct State {
        var loading: Bool
        var requireSignIn: Bool
        @Pulse var user: FirebaseAuth.User?
    }
    
    func transform(action: Observable<Action>) -> Observable<Action> {
        return action.debug("action")
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .checkSign:
            return authService.checkSignedUser()
                .flatMap { user in
                    if let user = user {
                        return Observable.concat([
                            Observable.just(Mutation.setLoading(true)),
                            Observable.just(Mutation.setLoading(false)),
                            Observable.just(Mutation.setUser(user)),
                        ])
                    } else {
                        return Observable.just(Mutation.setRequireSignIn(true))
                    }
                }
        case .requestAuth(let result):
            return authService.oAuthSignIn(result)
                .flatMap {
                    return Observable.concat([
                        Observable.just(Mutation.setUser($0)),
                        Observable.just(Mutation.setRequireSignIn(false)),
                        Observable.just(Mutation.setLoading(false)),
                    ])
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setLoading(let loading):
            state.loading = loading
        case .setRequireSignIn(let bool):
            state.requireSignIn = bool
        case .setUser(let user):
            state.user = user
        }
        return state
    }
}
