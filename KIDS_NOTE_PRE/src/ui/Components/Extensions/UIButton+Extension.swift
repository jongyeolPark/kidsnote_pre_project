//
//  UIButton+Extension.swift
//  KIDS_NOTE_PRE
//
//  Created by 박종열 on 2023/07/28.
//

import UIKit

extension UIButton {

    func setBackgroundColor(_ color: UIColor?, for state: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1.0, height: 1.0))
        guard let context = UIGraphicsGetCurrentContext() else { return }
        if let cgcolor = color?.cgColor {
            context.setFillColor(cgcolor)
        }
        context.fill(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))

        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        self.setBackgroundImage(backgroundImage, for: state)
    }
}
