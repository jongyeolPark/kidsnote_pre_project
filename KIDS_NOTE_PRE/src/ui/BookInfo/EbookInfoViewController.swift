//
//  EbookInfoViewController.swift
//  KIDS_NOTE_PRE
//
//  Created by 박종열 on 2023/07/30.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxCocoa

class EbookInfoViewController: BaseViewController, View {
    
    private lazy var scrollView: UIScrollView = UIScrollView().then {
        $0.alwaysBounceVertical = true
        $0.contentInset = .init(top: 20, left: 0, bottom: 20, right: 0)
        $0.addSubview(descriptionLabel)
    }
    
    private let descriptionLabel = UILabel().then {
        $0.textColor = .gray800
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.numberOfLines = 0
    }
    
    override func snapKitView() -> [UIView] {
        [scrollView]
    }
    
    override func snapKitMakeConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.centerX.top.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    func bind(reactor: EbookInfoViewReactor) {
        reactor.state.map { $0.description }
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.title }
            .bind(to: rx.title)
            .disposed(by: disposeBag)
    }
}
