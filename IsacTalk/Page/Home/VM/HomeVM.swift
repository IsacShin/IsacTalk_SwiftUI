//
//  HomeVM.swift
//  IsacTalk
//
//  Created by 신이삭 on 2023/09/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct FirebaseContants {
    static let fromId = "fromId"
    static let toId = "toId"
    static let text = "text"
    static let timestamp = "timestamp"
    static let profileImageUrl = "profileImageUrl"
    static let email = "email"
    static let img = "img"
    static let name = "name"
    static let isRead = "isRead"
}

final class HomeVM: ObservableObject {
    
    @Published var errMsg = ""
    @Published var chatUser: ChatUser?
    @Published var isUserCurrentlyLoggedOut = false
    @Published var recentMessages = [RecentMessage]()
    
    private var firestoreListener: ListenerRegistration?
    
    init() {
        DispatchQueue.main.async {
            self.isUserCurrentlyLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil
        }
        fetchCurrentUser()
        fetchRecentMessage()
    }
    
    func fetchRecentMessage() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        //파이어베이스 스토어 순환참조 방지
        self.firestoreListener?.remove()

        self.recentMessages.removeAll()
        
        firestoreListener = FirebaseManager.shared.firestore
            .collection("recent_messages")
            .document(uid)
            .collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { querySnapshot, err in
                if let err = err {
                    self.errMsg = "Failed to listen for recent messages: \(err)"
                    print(err)
                    return
                }
                
                querySnapshot?.documentChanges.forEach({ change in
                    let docId = change.document.documentID
                    
                    // 최근메세지 중복 제거
                    if let index = self.recentMessages.firstIndex(where: { rm in
                        rm.id == docId
                    }) {
                        self.recentMessages.remove(at: index)
                    }
                    
                    do {
                        let rm = try change.document.data(as: RecentMessage.self)
                        self.recentMessages.insert(rm, at: 0)
                    } catch {
                        print(error)
                    }

                })
            }
    }
    
    func fetchCurrentUser() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            self.errMsg = "Could not find firebase uid"
            return
        }

        FirebaseManager.shared.firestore.collection("users")
            .document(uid).getDocument { snapshot, err in
                if let err = err {
                    self.errMsg = "Failed to fetch current user: \(err)"
                    print("Failed to fetch current user:", err)
                }
                
                guard let data = snapshot?.data() else {
                    self.errMsg = "No data found"
                    return
                }
                
                self.chatUser = .init(data: data)
                AppManager.loginUser = self.chatUser
            }
    }
    
    func handleSignOut() {
        isUserCurrentlyLoggedOut.toggle()
        try? FirebaseManager.shared.auth.signOut()
    }
}
