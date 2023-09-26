//
//  Date+Ext.swift
//  IsacTalk
//
//  Created by 신이삭 on 2023/09/25.
//

import Foundation

extension Date {
    func formattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        if Calendar.current.isDateInToday(self) {
            dateFormatter.dateFormat = "a h:mm"
        } else {
            dateFormatter.dateFormat = "yy.M.dd HH:mm"
        }
        
        let formattedDate = dateFormatter.string(from: self)
        return formattedDate
    }
    
    func formattedTimestampDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyMMddHHmmss"
        return dateFormatter.string(from: self)
    }
}
