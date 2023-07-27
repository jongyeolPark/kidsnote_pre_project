//
//  IntroViewController.swift
//  KIDS_NOTE_PRE
//
//  Created by 박종열 on 2023/07/27.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxCocoa
import GoogleSignIn
import FirebaseAuth

class IntroViewController: UIViewController, View {
    
    var disposeBag = DisposeBag()
    
    private let signInbutton = UIButton(type: .roundedRect).then {
        $0.setTitle("SIGN IN", for: .normal)
    }
    
    private let signOutbutton = UIButton(type: .roundedRect).then {
        $0.setTitle("SIGN OUT", for: .normal)
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        reactor = IntroViewReactor(authService: AuthService.shared)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(signInbutton)
        self.view.addSubview(signOutbutton)
        signInbutton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        signOutbutton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(signInbutton.snp.bottom).offset(20)
        }
        signOutbutton.rx.tap
            .bind {
                do {
                    try Auth.auth().signOut()
                } catch {
                    print(error)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func bind(reactor: IntroViewReactor) {
        print("##########################################")
        reactor.state.map { $0.requireSignIn }
            .filter { $0 }
            .withUnretained(self)
            .bind { (owner, signed) in
                print("# requireSignIn = \(signed)")
                Task {
                    do {
                        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: self)
                        owner.reactor?.action.onNext(.requestAuth(result))
                    } catch {
                        print(error)
                    }
                }
            }.disposed(by: disposeBag)
        
        reactor.state.map { $0.loading }
            .skip(1)
            .distinctUntilChanged()
            .bind { loading in
                print("# loading = \(loading)")
            }.disposed(by: disposeBag)
        
        reactor.pulse(\.$user)
            .bind { user in
                print("# user = \(user)")
            }.disposed(by: disposeBag)
        
        signInbutton.rx.tap
            .map { IntroViewReactor.Action.checkSign }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        Observable.just(IntroViewReactor.Action.checkSign)
            .debug()
            .delay(.milliseconds(100), scheduler: MainScheduler.instance)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}

