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
        dateFormatter.dateFormat = "yy.MM.dd HH:mm"
        return dateFormatter.string(from: self)
    }
    
    func formattedTimestampDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyMMddHHmmss"
        return dateFormatter.string(from: self)
    }
}
