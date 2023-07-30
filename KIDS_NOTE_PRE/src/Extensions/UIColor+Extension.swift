//
//  UIColor+Extension.swift
//  KIDS_NOTE_PRE
//
//  Created by 박종열 on 2023/07/30.
//

import UIKit

extension UIColor {
    var toImage: UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        self.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }

    convenience init(rgb: Int) {
        self.init(red: (rgb >> 16) & 0xFF, green: (rgb >> 8) & 0xFF, blue: rgb & 0xFF)
    }

    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        var color: UInt64 = 0
        if scanner.scanHexInt64(&color) {
            let red = Int(color >> 16 & 0xff)
            let green = Int(color >> 8 & 0xff)
            let blue = Int(color & 0xff)
            self.init(red: red, green: green, blue: blue)
        } else {
            self.init(red: 0, green: 0, blue: 0)
        }
    }

    convenience init(hex: String, alpha: CGFloat) {
        let scanner = Scanner(string: hex)
        var color: UInt64 = 0
        if scanner.scanHexInt64(&color) {
            let red = Int(color >> 16 & 0xff)
            let green = Int(color >> 8 & 0xff)
            let blue = Int(color & 0xff)
            self.init(red: red, green: green, blue: blue, alpha: alpha)
        } else {
            self.init(red: 0, green: 0, blue: 0)
        }
    }
}
