//
//  LoadingView.swift
//  KIDS_NOTE_PRE
//
//  Created by 박종열 on 2023/07/28.
//

import UIKit
import Lottie

class LoadingView: LottieAnimationView {

    static let TAG = 9999

    init() {
        super.init(frame: .zero)
        self.tag = LoadingView.TAG
        let anim = LottieAnimation.named("lottie_loading", bundle: Bundle.main)
        animation = anim
        animationSpeed = 1.0
        loopMode = .loop
        contentMode = .scaleAspectFit
        isHidden = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func show() {
        play()
        isHidden = false
    }

    func hide() {
        stop()
        isHidden = true
    }
}
