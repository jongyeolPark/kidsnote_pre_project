//
//  PosterView.swift
//  KIDS_NOTE_PRE
//
//  Created by 박종열 on 2023/07/30.
//

import UIKit

class PosterView: UIImageView {
    
    init() {
        super.init(frame: .zero)
        layer.cornerRadius = 8
        clipsToBounds = true
        layer.masksToBounds = false
        layer.backgroundColor = UIColor.gray100.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddSubview(_ subview: UIView) {
        
    }
}
