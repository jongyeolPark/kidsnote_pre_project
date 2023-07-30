//
//  DividerView.swift
//  KIDS_NOTE_PRE
//
//  Created by 박종열 on 2023/07/30.
//

import UIKit

class DividerView: UIView {
    
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.height = 1
        return size
    }
    
    init(_ backgroundColor: UIColor = .gray100) {
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
}
