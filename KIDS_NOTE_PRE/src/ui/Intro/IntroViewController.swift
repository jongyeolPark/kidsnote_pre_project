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

class IntroViewController: BaseViewController, View {
     
    private let logoImage = UIImageView(image: .init(named: "ic_logo")).then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let signInbutton = UIButton(type: .roundedRect).then {
        $0.setTitle("로그인", for: .normal)
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        reactor = IntroViewReactor(authService: AuthService.shared)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    
    override func snapKitView() -> [UIView] {
        [logoImage, signInbutton]
    }
    
    override func snapKitMakeConstraints() {
        
        logoImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-40)
            make.width.height.equalTo(160)
        }
        
        signInbutton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(0)
            make.height.equalTo(48)
        }
    }
    
    override func viewSafeAreaInsetsDidChange() {
        signInbutton.snp.updateConstraints { make in
            make.bottom.equalToSuperview().inset(view.safeAreaInsets.bottom)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bind(reactor: IntroViewReactor) {
        
        reactor.state.map { $0.loading }
            .skip(1)
            .withUnretained(self)
            .bind { owner, loading in
                owner.showLoadingDialog(loading)
            }.disposed(by: disposeBag)
        
        reactor.pulse(\.$user)
            .skip(1)
            .observe(on: MainScheduler.instance)
            .compactMap { $0 }
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind { owner, user in
                let vc = SearchViewController()
                vc.reactor = SearchViewReactor(bookService: BookService.shared, user: user)
                let navi = BaseNavigationController(rootViewController: vc)
                navi.modalTransitionStyle = .crossDissolve
                navi.modalPresentationStyle = .fullScreen
                owner.present(navi, animated: true)
                
            }.disposed(by: disposeBag)
        
        reactor.state.map { $0.requireSignIn }
            .bind(to: signInbutton.rx.isEnabled )
            .disposed(by: disposeBag)
        
        signInbutton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                Task {
                    do {
                        owner.showLoadingDialog(true)
                        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: self)
                        owner.reactor?.action.onNext(.requestAuth(result))
                    } catch {
                        owner.showLoadingDialog(false)
                        print(error)
                    }
                }
            }
            .disposed(by: disposeBag)

        Observable.just(IntroViewReactor.Action.checkSign)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}
