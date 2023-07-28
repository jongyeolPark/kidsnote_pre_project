//
//  SearchListEmptyCell.swift
//  KIDS_NOTE_PRE
//
//  Created by 박종열 on 2023/07/28.
//

import UIKit
import SnapKit
import Then

class SearchListEmptyCell: BaseCollectionViewCell {
    static let reuseIdentifier = "SearchListEmptyCellReuseIdentifier"
    
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12, weight: .medium)
        $0.textColor = .gray700
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.text = "eBook 검색결과 없음"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
