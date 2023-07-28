//
//  SearchListFooter.swift
//  KIDS_NOTE_PRE
//
//  Created by 박종열 on 2023/07/28.
//

import UIKit
import SnapKit
import Lottie
import Then

class SearchListFooter: UICollectionReusableView {
    
    static let reuseIdentifier = "SearchListFooterReuseIdentifier"
    
    private let loadingView = LottieAnimationView().then { v in
        
        let anim = LottieAnimation.named("lottie_loading", bundle: Bundle.main)
        v.animation = anim
        v.animationSpeed = 1.0
        v.loopMode = .loop
        v.contentMode = .scaleAspectFit
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(40)
        }
        loadingView.play()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
