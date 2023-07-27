//
//  AuthServcie.swift
//  KIDS_NOTE_PRE
//
//  Created by 박종열 on 2023/07/27.
//

import Foundation
import RxSwift
import FirebaseAuth
import GoogleSignIn

protocol AuthServiceProtocol: AnyObject {
    func checkSignedUser() -> Observable<FirebaseAuth.User?>
    func oAuthSignIn(_ result: GIDSignInResult) -> Observable<User>
}

class AuthService: AuthServiceProtocol {
    
    static let shared = AuthService()
    
    private init() { }
    
    func checkSignedUser() -> Observable<User?> {
        Observable<User?>.create { emit in
            Auth.auth().addStateDidChangeListener { (_, user) in
                emit.onNext(user)
            }
            return Disposables.create {
                emit.onCompleted()
            }
        }
    }
    
    func oAuthSignIn(_ result: GIDSignInResult) -> Observable<User> {
        Observable<User>.create { emit in
            Task {
                do {
                    let accessToken = result.user.accessToken.tokenString
                    guard let idToken = result.user.idToken?.tokenString else { return }
                    let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
                    let signInResult = try await Auth.auth().signIn(with: credential)
                    emit.onNext(signInResult.user)
                } catch {
                    emit.onError(error)
                }
            }
            
            return Disposables.create {
                emit.onCompleted()
            }
        }
    }
}
