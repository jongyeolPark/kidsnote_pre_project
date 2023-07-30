//
//  ReadSamplWishListView.swift
//  KIDS_NOTE_PRE
//
//  Created by 박종열 on 2023/07/30.
//

import UIKit
import SnapKit
import Then

class ReadSamplWishListView: UIView {
    
    private let dividerTopView = DividerView(.gray400)
    
    private let dividerBottomView = DividerView(.gray400)
    
    let readSampleButton = UIButton().then { b in
        b.clipsToBounds = true
        b.setTitleColor(.blue600, for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 12, weight: .regular)
        b.setBackgroundColor(.clear, for: .normal)
        b.setBackgroundColor(.blue200, for: .highlighted)
        b.layer.cornerRadius = 6
        b.layer.borderColor = UIColor.gray200.cgColor
        b.layer.borderWidth = 1
    }
    
    let addWishListButton = UIButton().then { b in
        b.clipsToBounds = true
        b.setTitleColor(.white, for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 12, weight: .regular)
        b.setBackgroundColor(.blue600, for: .normal)
        b.setBackgroundColor(.blue200, for: .highlighted)
        b.layer.cornerRadius = 6
        b.setImage(UIImage(systemName: "bookmark")?.withRenderingMode(.alwaysTemplate), for: .normal)
        b.tintColor = .white
        b.imageEdgeInsets = .init(top: 0, left: -6, bottom: 0, right: 6)
        b.adjustsImageWhenHighlighted = false
    }

    private let sampleInfoImage = UIImageView().then {
        $0.image = .init(systemName: "info.circle")?.withRenderingMode(.alwaysTemplate)
        $0.tintColor = .gray600
        $0.contentMode = .scaleAspectFit
    }
    
    private let sampleDescriptionLabel = UILabel().then {
        $0.text = "GooglePlay 웹사이트에서 구매한 책을 이 앱에서 읽을 수 있습니다."
        $0.font = .systemFont(ofSize: 10, weight: .regular)
        $0.textColor = .gray600
        $0.numberOfLines = 0
    }
    
    private lazy var descriptionView = UIView().then {
        $0.addSubview(sampleInfoImage)
        $0.addSubview(sampleDescriptionLabel)
        
        sampleInfoImage.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.width.height.equalTo(14)
        }
        
        sampleDescriptionLabel.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
            make.leading.equalTo(sampleInfoImage.snp.trailing).offset(8)
        }
    }
    
    init() {
        super.init(frame: .zero)
        [dividerTopView, readSampleButton, addWishListButton, descriptionView, dividerBottomView].forEach {
            self.addSubview($0)
        }
        
        dividerTopView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
        }
        
        readSampleButton.snp.makeConstraints { make in
            make.top.equalTo(dividerTopView.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(20)
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalTo(30)
        }
        
        addWishListButton.snp.makeConstraints { make in
            make.top.bottom.equalTo(readSampleButton)
            make.trailing.equalToSuperview().inset(20)
            make.leading.lessThanOrEqualTo(readSampleButton.snp.trailing).offset(8)
        }
        
        descriptionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(readSampleButton.snp.bottom).offset(8)
        }
        
        dividerBottomView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(descriptionView.snp.bottom).offset(8)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
