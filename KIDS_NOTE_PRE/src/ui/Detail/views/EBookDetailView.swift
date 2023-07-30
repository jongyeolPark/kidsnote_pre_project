//
//  EBookDetailView.swift
//  KIDS_NOTE_PRE
//
//  Created by 박종열 on 2023/07/30.
//

import UIKit
import SnapKit
import Then

class EBookDetailView: UIView {
    
    let posterView = PosterView()
    
    let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .medium)
        $0.numberOfLines = 0
        $0.textColor = .gray900
    }
    
    let authorLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.numberOfLines = 0
        $0.textColor = .gray900
    }
    
    let ebookLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 10, weight: .regular)
        $0.textColor = .gray700
    }
    
    init() {
        super.init(frame: .zero)
        [posterView, titleLabel, authorLabel, ebookLabel].forEach { self.addSubview($0) }
        
        posterView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
            make.width.equalTo(128)
            make.height.equalTo(180)
            make.bottom.lessThanOrEqualToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(posterView)
            make.leading.equalTo(posterView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().inset(16)
        }
        
        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(titleLabel)
            make.trailing.equalToSuperview().inset(16)
        }
        
        ebookLabel.snp.makeConstraints { make in
            make.top.equalTo(authorLabel.snp.bottom).offset(2)
            make.leading.equalTo(titleLabel)
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
