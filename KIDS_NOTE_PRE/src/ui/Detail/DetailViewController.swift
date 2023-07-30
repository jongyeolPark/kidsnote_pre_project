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
    
    private let detailView = EBookDetailView()
        
    private let readSamplWishListView = ReadSamplWishListView()
    
    private let ebookInfoButton = EbookInfoButton()
    
    private let publishView = EBookPublishView()
    
    override func snapKitView() -> [UIView] {
        [detailView, readSamplWishListView, ebookInfoButton, publishView]
    }
    
    override func snapKitMakeConstraints() {
        detailView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().inset(16)
        }
        
        readSamplWishListView.snp.makeConstraints { make in
            make.top.equalTo(detailView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
        }
        
        ebookInfoButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(readSamplWishListView.snp.bottom).offset(8)
        }
        
        publishView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(ebookInfoButton.snp.bottom).offset(8)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
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
        
        Observable.just("샘플 읽기")
            .bind(to: readSamplWishListView.readSampleButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
        
        Observable.just("위시리스트에 추가")
            .bind(to: readSamplWishListView.addWishListButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
        
        ebookInfoButton.rx.tap
            .bind { _ in
                print("ebookInfoButton.rx.tap")
            }.disposed(by: disposeBag)
    }
}
