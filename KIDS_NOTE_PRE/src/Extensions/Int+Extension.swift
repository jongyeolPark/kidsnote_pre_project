//
//  Int+Extension.swift
//  KIDS_NOTE_PRE
//
//  Created by 박종열 on 2023/07/30.
//

import Foundation

extension Int {
    func decimalComma(_ postFix: String = "") -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        if let result = numberFormatter.string(from: NSNumber(value: self)) {
            return "\(result)\(postFix)"
        }
        return "\(self)\(postFix)"
    }
}
