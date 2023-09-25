//
//  ChatLogV.swift
//  IsacTalk
//
//  Created by 신이삭 on 2023/09/25.
//

import SwiftUI
import Firebase

class ChatLogVM: ObservableObject {
    
    @Published var chatText = ""
    @Published var chatImg: String?
    @Published var errMsg = ""
    @Published var chatMessages = [ChatMessage]()
    @Published var count = 0
    
    var firestoreListener: ListenerRegistration?
    
    var chatUser: ChatUser?
    
    init(chatUser: ChatUser?) {
        self.chatUser = chatUser
        
        fetchMessages()
    }
    
    func fetchMessages() {
        // 보내는 사람
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        // 받는 사람
        guard let toId = chatUser?.uid else { return }
        firestoreListener?.remove()
        chatMessages.removeAll()
        // 발신자 문서
        firestoreListener = FirebaseManager.shared.firestore
            .collection("messages")
            .document(fromId)
            .collection(toId)
            .order(by: "timestamp")
            .addSnapshotListener { querySnapshot, err in
                if let err = err {
                    self.errMsg = "Failed to listen for messages: \(err)"
                    print(err)
                    return
                }
                
                querySnapshot?.documentChanges.forEach({ change in
                    if change.type == .added {
                        do {
                            let cm = try change.document.data(as: ChatMessage.self)
                            
                            self.chatMessages.append(cm)
                            
                            // 읽음 표시
                            let messageId = change.document.documentID

                            let readStatusRef = Database.database().reference().child("messages").child(messageId).child("readStatus").child(fromId)
                            readStatusRef.setValue(true)
                        
                            Database.database().reference().child("messages").child(messageId).child("readStatus").observe(DataEventType.value) { snapshot in
                                let numberOfReaders = snapshot.childrenCount
                                if let chatMessageIndex = self.chatMessages.firstIndex(where: { $0.id == messageId }) {
                                    self.chatMessages[chatMessageIndex].isRead = numberOfReaders > 1
                                }
                            }

                        } catch {
                            print(error)
                        }
                        
                    }
                })
                
                // 오토 스크롤 메세지 가장 밑으로 스크롤 되게 카운터 증가
                DispatchQueue.main.async {
                    self.count += 1
                }
                
            }
    }
    
    func handleSend(sendImg: UIImage?) {
        print(self.chatText)
        // 보내는 사람
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        // 받는 사람
        guard let toId = chatUser?.uid else { return }
        
        var messageData = [
            FirebaseContants.fromId: fromId,
            FirebaseContants.toId: toId,
            FirebaseContants.text: self.chatText,
            FirebaseContants.img: "",
            FirebaseContants.timestamp: Timestamp(),
            FirebaseContants.isRead: false
        ] as [String: Any]
        
        if let sendImg = sendImg {
            persistImageToStorage(fileImg: sendImg) { imgUrl in
                messageData = [
                    FirebaseContants.fromId: fromId,
                    FirebaseContants.toId: toId,
                    FirebaseContants.text: "사진을 보냈습니다.",
                    FirebaseContants.img: imgUrl,
                    FirebaseContants.timestamp: Timestamp(),
                    FirebaseContants.isRead: false
                ] as [String: Any]
                self.sendMessage(messageData: messageData, sendImg: sendImg)
            }
        } else {
            sendMessage(messageData: messageData)
        }
 
    }
    
    private func persistImageToStorage(fileImg: UIImage? = nil, completion: @escaping (String) -> Void) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        let ref = FirebaseManager.shared.storage.reference(withPath: "chat/" + uid)
        
        guard let imageData = fileImg?.jpegData(compressionQuality: 0.1) else { return }
        ref.putData(imageData) { metaData, err in
            if let err = err {
                print(err.localizedDescription)
                return
            }
            
            ref.downloadURL { url, err in
                if let err = err {
                    print(err.localizedDescription)
                    return
                }
                
                print("Successfully stored image with url: \(url?.absoluteString ?? "")")
                guard let url = url?.absoluteString else { return }
                completion(url)
            }
        }
    }
    
    private func sendMessage(messageData: [String: Any], sendImg: UIImage? = nil) {
        // 보내는 사람
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        // 받는 사람
        guard let toId = chatUser?.uid else { return }
        
        guard let timestamp = messageData[FirebaseContants.timestamp] as? Timestamp else { return }
        
        // 발신자 문서
        let document = FirebaseManager.shared.firestore
            .collection("messages")
            .document(fromId)
            .collection(toId)
            .document(timestamp.dateValue().formattedTimestampDate())
        
        document.setData(messageData) { err in
            if let err = err {
                self.errMsg = "Failed to save message into Firestore: \(err)"
                print(err)
                return
            }
            
            print("Success save Message!!")
            
            self.persistRecentMessage(sendImg: sendImg)
            
            self.chatText = ""
            self.count += 1
        }
        
        // 수신자 문서
        let recipientMessageDocument = FirebaseManager.shared.firestore
            .collection("messages")
            .document(toId)
            .collection(fromId)
            .document(timestamp.dateValue().formattedTimestampDate())
        
        recipientMessageDocument.setData(messageData) { err in
            if let err = err {
                self.errMsg = "Failed to save message into Firestore: \(err)"
                print(err)
                return
            }
            
            print("Success recipent save Message!!")
        }
    }
    
    // 최근 메세지 저장
    private func persistRecentMessage(sendImg: UIImage? = nil) {
        guard let chatUser = self.chatUser else { return }
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toId = self.chatUser?.uid else { return }
        let document = FirebaseManager.shared.firestore
            .collection("recent_messages")
            .document(uid)
            .collection("messages")
            .document(toId)
        
        let data = [
            FirebaseContants.timestamp: Timestamp(),
            FirebaseContants.text: sendImg == nil ? self.chatText : "사진을 보냈습니다.",
            FirebaseContants.fromId: uid,
            FirebaseContants.name: chatUser.name,
            FirebaseContants.toId: toId,
            FirebaseContants.profileImageUrl: chatUser.profileImageUrl,
            FirebaseContants.email: chatUser.email
        ] as [String: Any]
        
        document.setData(data) { err in
            if let err = err {
                self.errMsg = "Failed to save recent message: \(err)"
                print("Failed to save recent message: \(err)")
                return
                
            }
        }
        
        // 수신자
        guard let currentUser = AppManager.loginUser else { return }
        let recipientRecentMessageDictionary = [
            FirebaseContants.timestamp: Timestamp(),
            FirebaseContants.text: self.chatText,
            FirebaseContants.name: currentUser.name,
            FirebaseContants.fromId: uid,
            FirebaseContants.toId: toId,
            FirebaseContants.profileImageUrl: currentUser.profileImageUrl,
            FirebaseContants.email: currentUser.email
        ] as [String : Any]
        
        FirebaseManager.shared.firestore
            .collection("recent_messages")
            .document(toId)
            .collection("messages")
            .document(currentUser.uid)
            .setData(recipientRecentMessageDictionary) { error in
                if let error = error {
                    print("Failed to save recipient recent message: \(error)")
                    return
                }
            }
        
    }
}
