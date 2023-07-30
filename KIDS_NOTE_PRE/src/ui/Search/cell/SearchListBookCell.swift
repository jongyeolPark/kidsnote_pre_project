//
//  SearchListBookCell.swift
//  KIDS_NOTE_PRE
//
//  Created by 박종열 on 2023/07/28.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxDataSources
import RxSwift

class SearchListBookCell: BaseCollectionViewCell, View {
    
    static let reuseIdentifier = "SearchListBookCellReuseIdentifier"
    
    var disposeBag = DisposeBag()
    
    private let posterView = PosterView()
    
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .gray900
        $0.numberOfLines = 0
    }

    private let authorLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 10, weight: .regular)
        $0.textColor = .gray700
        $0.numberOfLines = 0
    }

    private let ebookLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 10, weight: .regular)
        $0.textColor = .gray700
        $0.numberOfLines = 0
    }
    
    private let ratingLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 10, weight: .regular)
        $0.textColor = .gray700
        $0.numberOfLines = 0
    }
    
    private let ratingImage = UIImageView().then {
        $0.image = .init(systemName: "star.fill")?.withRenderingMode(.alwaysTemplate)
        $0.tintColor = .gray700
        $0.contentMode = .scaleAspectFit
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(posterView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(authorLabel)
        self.contentView.addSubview(ebookLabel)
        self.contentView.addSubview(ratingLabel)
        self.contentView.addSubview(ratingImage)
        
        posterView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(20)
            make.bottom.lessThanOrEqualToSuperview().inset(20)
            make.height.equalTo(56)
            make.width.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(posterView.snp.trailing).offset(10)
            make.top.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(20)
        }

        authorLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
        }

        ebookLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(authorLabel.snp.bottom).offset(2)
            make.bottom.lessThanOrEqualToSuperview().inset(20)
        }

        ratingLabel.snp.makeConstraints { make in
            make.leading.equalTo(ebookLabel.snp.trailing).offset(4)
            make.top.equalTo(ebookLabel)
        }

        ratingImage.snp.makeConstraints { make in
            make.leading.equalTo(ratingLabel.snp.trailing).offset(4)
            make.centerY.equalTo(ratingLabel)
            make.width.height.equalTo(12)
        }
        
        self.selectedBackgroundView = UIView().then {
            $0.backgroundColor = .lightGray
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    func bind(reactor: SearchListBookCellReactor) {
        reactor.state.compactMap { $0.volumeInfo }
            .map {
                if let subtitle = $0.subtitle, !subtitle.isEmpty {
                    return "\($0.title): \(subtitle)"
                } else {
                    return $0.title
                }
            }
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.volumeInfo?.imageLinks?.smallThumbnail }
            .withUnretained(self)
            .asDriver(onErrorJustReturn: (self, ""))
            .drive { owner, url in
                owner.posterView.loadImage(url)
            }.disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.volumeInfo?.authors?.joined(separator: "·") }
            .bind(to: authorLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.saleInfo?.isEbook ?? false }
            .map { $0 ? "eBook" : nil }
            .bind(to: ebookLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.saleInfo?.isEbook ?? false }
            .map { !$0 }
            .bind(to: ratingImage.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.saleInfo?.isEbook ?? false }
            .map { $0 ? "5.0" : nil }
            .bind(to: ratingLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
