//
//  ChatMessage.swift
//  IsacTalk
//
//  Created by 신이삭 on 2023/09/23.
//

import Foundation
import FirebaseFirestoreSwift

struct ChatMessage: Codable, Identifiable {
    @DocumentID var id: String?
    let fromId, toId, text: String
}

