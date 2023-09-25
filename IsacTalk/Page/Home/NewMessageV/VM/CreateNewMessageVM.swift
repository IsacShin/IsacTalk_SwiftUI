//
//  CreateNewMessageVM.swift
//  IsacTalk
//
//  Created by 신이삭 on 2023/09/23.
//

import Foundation

final class CreateNewMessageVM: ObservableObject {
    @Published var users = [ChatUser]()
    init() {
        fetchChatUser()
    }
    
    private func fetchChatUser() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let db = FirebaseManager.shared.firestore
        db.collection("users")
            .getDocuments { snapshot, err in
                if let err = err {
                    print("Failed to fetch users: \(err)")
                    return
                }
                
                snapshot?.documents.forEach({ snapshot in
                    let data = snapshot.data()
                    let user = ChatUser(data: data)
                    
                    db.collection("users").document(uid)
                        .getDocument { document, err in
                            if let err = err {
                                print("Failed to fetch users: \(err)")
                                return
                            }
                            
                            if let document = document, document.exists {
                                var existingArray = document.data()?["friends"] as? [String] ?? []
                                existingArray.forEach {
                                    if user.uid == $0 {
                                        self.users.append(.init(data: data))
                                    }
                                    
                                }
                            }
                            
                        }
                })
                
            }
    }
}
