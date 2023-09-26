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
    case isEmptyCode = "코드를 입력해주세요."
    case codeShareSuccess = "코드가 전송되었습니다."
    case addFriendsSuccess = "친구가 추가되었습니다."
    case addFriendsFailed = "자신을 친구로 추가할 수 없습니다."
    case isValidFailed = "이미 추가한 친구 입니다."
    case loginOutConfirm = "로그아웃 하시겠습니까?"
    case chatDeleteConfirm = "대화방을 나가시겠습니까?"
    case removeMemberConfirm = "회원을 탈퇴하시겠습니까?\n탈퇴하실 경우 대화중인 채팅방 모두 삭제됩니다."

}
