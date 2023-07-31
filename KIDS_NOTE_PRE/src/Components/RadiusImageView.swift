//
//  RadiusImageView.swift
//  KIDS_NOTE_PRE
//
//  Created by 박종열 on 2023/07/31.
//

import UIKit
import SnapKit

class RadiusImageView: UIView {
    
    var cornerRadius: CGFloat = 8 {
        didSet {
            layer.cornerRadius = cornerRadius
            imageView.layer.cornerRadius = cornerRadius
            layoutIfNeeded()
        }
    }
    
    var image: UIImage? = nil {
        didSet {
            imageView.image = image
            layoutIfNeeded()
        }
    }
    
    override var contentMode: UIView.ContentMode {
        didSet {
            imageView.contentMode = contentMode
            layoutIfNeeded()
        }
    }
        
    let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        clipsToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 6
        layer.shadowOpacity = 0.5
        self.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
