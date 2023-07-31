//
//  DetailViewController.swift
//  KIDS_NOTE_PRE
//
//  Created by 박종열 on 2023/07/30.
//

import UIKit
import SnapKit
import Then
import ReactorKit

class DetailViewController: BaseViewController, View {
    
    private let navShareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: nil, action: nil)

    private lazy var scrollView: UIScrollView = UIScrollView().then {
        $0.alwaysBounceVertical = true
        $0.contentInset = .init(top: 20, left: 0, bottom: 20, right: 0)
        $0.addSubview(scrollContentView)
    }
    
    private lazy var scrollContentView = UIStackView(arrangedSubviews: [detailView, readSamplWishListView, ebookInfoButton, publishView]).then {
        $0.axis = .vertical
        $0.setCustomSpacing(16, after: detailView)
        $0.setCustomSpacing(16, after: readSamplWishListView)
        $0.setCustomSpacing(8, after: ebookInfoButton)
    }
    
    private let detailView = EBookDetailView()
        
    private let readSamplWishListView = ReadSamplWishListView()
    
    private let ebookInfoButton = EbookInfoButton()
    
    private let publishView = EBookPublishView()
    
    override func snapKitView() -> [UIView] {
        [scrollView]
    }
    
    override func snapKitMakeConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        scrollContentView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.centerX.top.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.rightBarButtonItem = navShareButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func bind(reactor: DetailViewReactor) {
        reactor.state.compactMap { $0.thumbnail }
            .distinctUntilChanged()
            .withUnretained(self)
            .bind { owner, url in
                owner.detailView.posterView.loadImage(url)
            }.disposed(by: disposeBag)
        
        reactor.state.map { $0.title }
            .distinctUntilChanged()
            .bind(to: detailView.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.authors }
            .distinctUntilChanged()
            .bind(to: detailView.authorLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.authors }
            .bind(to: detailView.authorLabel.rx.text)
            .disposed(by: disposeBag)

        reactor.state.compactMap { $0.ebookPageCount }
            .bind(to: detailView.ebookLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.description }
            .bind(to: ebookInfoButton.descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.publishInfo }
            .bind(to: publishView.publishLabel.rx.text)
            .disposed(by: disposeBag)
        
        navShareButton.rx.tap
            .map { DetailViewReactor.Action.share }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
                
        Observable.just("샘플 읽기")
            .bind(to: readSamplWishListView.readSampleButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
        
        readSamplWishListView.readSampleButton.rx.tap
            .map { DetailViewReactor.Action.readSample }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.pulse { $0.$wishButtonText }
            .bind(to: readSamplWishListView.addWishListButton.rx.title(for: .normal))
            .disposed(by: disposeBag)

        readSamplWishListView.addWishListButton.rx.tap
            .map { DetailViewReactor.Action.toggleWishList }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        ebookInfoButton.rx.tap
            .map { DetailViewReactor.Action.ebookInfo }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.pulse { $0.$shareData }
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .withUnretained(self)
            .bind { owner, data in
                let activityVC = UIActivityViewController(activityItems: data, applicationActivities: nil)
                activityVC.popoverPresentationController?.sourceView = owner.view
                owner.present(activityVC, animated: true, completion: nil)
            }.disposed(by: disposeBag)
        
        reactor.pulse { $0.$ebookInfo }
            .compactMap { $0 }
            .withUnretained(self)
            .bind { owner, info in
                let vc = EbookInfoViewController()
                vc.reactor = EbookInfoViewReactor(info: info)
                owner.navigationController?.pushViewController(vc, animated: true)
            }.disposed(by: disposeBag)
        
        reactor.pulse { $0.$ISBN }
            .filter { !$0.isEmpty }
            .withUnretained(self)
            .bind { owner, isbn in
                print("ISBN:\(isbn)")
//                let vc = EbookViewerViewController(identifier: isbn)
//                vc.modalTransitionStyle = .coverVertical
//                vc.modalPresentationStyle = .fullScreen
//                owner.present(vc, animated: true)
            }.disposed(by: disposeBag)
    }
}
