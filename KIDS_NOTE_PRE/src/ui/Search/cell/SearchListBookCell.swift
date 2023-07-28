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
    
    private let posterView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .lightGray
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 18, weight: .bold)
        $0.textColor = .gray900
        $0.numberOfLines = 0
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(posterView)
        self.contentView.addSubview(titleLabel)
        
        posterView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.height.equalTo(80)
            make.top.bottom.equalToSuperview().inset(20)
            make.width.equalTo(contentView.snp.height).multipliedBy(0.4)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(posterView.snp.trailing).offset(10)
            make.top.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(20)
        }
        
        self.selectedBackgroundView = UIView().then {
            $0.backgroundColor = .lightGray
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(reactor: SearchListBookCellReactor) {
        reactor.state.map { $0.volumeInfo?.title }
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

