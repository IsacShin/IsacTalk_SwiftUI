//
//  ChatUser.swift
//  IsacTalk
//
//  Created by 신이삭 on 2023/09/22.
//

import Foundation

struct ChatUser: Identifiable {
    
    var id: String { uid }
    
    let uid, email, name, profileImageUrl: String
    
    init(data: [String: Any]) {
        self.uid = data["uid"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.name = data["name"] as? String ?? ""
        self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
    }
}
