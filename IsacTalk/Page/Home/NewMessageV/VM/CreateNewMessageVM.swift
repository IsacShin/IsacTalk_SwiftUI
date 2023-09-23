//
//  CreateNewMessageVM.swift
//  IsacTalk
//
//  Created by 신이삭 on 2023/09/23.
//

import Foundation

final class CreateNewMessageVM: ObservableObject {
    @Published var users = [ChatUser]()
    @Published var errorMsg = ""
    init() {
        fetchAllUser()
    }
    
    private func fetchAllUser() {
        FirebaseManager.shared.firestore.collection("users")
            .getDocuments { snapshot, err in
                if let err = err {
                    self.errorMsg = "Failed to fetch users: \(err)"
                    print("Failed to fetch users: \(err)")
                    return
                }
                
                snapshot?.documents.forEach({ snapshot in
                    let data = snapshot.data()
                    let user = ChatUser(data: data)
                    // 내 계정 제거
                    if user.uid != FirebaseManager.shared.auth.currentUser?.uid {
                        self.users.append(.init(data: data))
                    }
                })
                
            }
    }
}
