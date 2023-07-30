//
//  EBookPublishView.swift
//  KIDS_NOTE_PRE
//
//  Created by 박종열 on 2023/07/30.
//

import UIKit
import SnapKit
import Then

class EBookPublishView: UIView {
    
    private let titleLabel = UILabel().then {
        $0.text = "게시일"
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .gray900
    }
    
    let publishLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.textColor = .gray700
    }
    
    init() {
        super.init(frame: .zero)
        self.addSubview(titleLabel)
        self.addSubview(publishLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(20)
        }
        
        publishLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(14)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
