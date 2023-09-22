//
//  AlertType.swift
//  IsacTalk
//
//  Created by 신이삭 on 2023/09/18.
//

import Foundation

enum AlertType: String, CaseIterable {
    case joinSuccess = "가입되었습니다."
    case isJoinFailed = "문제가 발생하였습니다.\n다시 시도해주세요."
    case isJoinedAlert = "이미 가입한 사용자 입니다."


}
