//
//  EbookInfoButton.swift
//  KIDS_NOTE_PRE
//
//  Created by 박종열 on 2023/07/30.
//

import UIKit
import SnapKit
import Then

class EbookInfoButton: UIButton {
    
    private let buttonTitleLabel = UILabel().then {
        $0.text = "eBook 정보"
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.textColor = .gray900
    }
    
    let descriptionLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.textColor = .gray700
        $0.numberOfLines = 4
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private let arrowRight = UIImageView().then {
        $0.image = .init(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate)
        $0.tintColor = .blue600
    }
    
    init() {
        super.init(frame: .zero)
        self.addSubview(buttonTitleLabel)
        self.addSubview(arrowRight)
        self.addSubview(descriptionLabel)
        
        buttonTitleLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(20)
        }
        arrowRight.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalTo(buttonTitleLabel)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(buttonTitleLabel.snp.bottom).offset(14)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
        }
        setBackgroundColor(.gray200, for: .highlighted)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
