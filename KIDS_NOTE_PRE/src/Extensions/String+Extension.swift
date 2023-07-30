//
//  String+Extension.swift
//  KIDS_NOTE_PRE
//
//  Created by 박종열 on 2023/07/30.
//

import Foundation

extension String {
    func koDateFormat() -> String {
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = inputDateFormatter.date(from: self) else {
            return self
        }
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "yyyy년 M월 d일"
        let formattedDate = outputDateFormatter.string(from: date)
        return formattedDate
    }
}
