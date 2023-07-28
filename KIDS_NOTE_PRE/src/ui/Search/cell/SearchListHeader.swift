//
//  SearchListHeader.swift
//  KIDS_NOTE_PRE
//
//  Created by 박종열 on 2023/07/28.
//

import UIKit
import SnapKit
import Then

class SearchListHeader: UICollectionReusableView {
    
    static let reuseIdentifier = "SearchListHeaderReuseIdentifier"
    
    let titleView = UILabel().then {
        $0.textColor = .gray800
        $0.font = .systemFont(ofSize: 18, weight: .medium)
        $0.text = "Google Play 검색결과"
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(titleView)

        titleView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(4)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
