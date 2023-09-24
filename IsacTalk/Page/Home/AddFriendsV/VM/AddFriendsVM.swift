//
//  AddFriendsVM.swift
//  IsacTalk
//
//  Created by 신이삭 on 2023/09/24.
//

import Foundation
import SwiftUI
import Combine
import Firebase
import FirebaseFirestore

class AddFriendsVM: ObservableObject {
    @Published var isSuccess = false
    @Published var isFailed = false
    @Published var isValidFailed = false
    
    func storeUserFriends(code: String, completion: (() -> Void)? = nil) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        // Firestore 데이터베이스 참조
        let db = FirebaseManager.shared.firestore

        // 문서 참조
        let fromDocRef = db.collection("users").document(uid)
        let toDocRef = db.collection("users").document(code)

        // 가져올 필드 이름
        let fieldName = "friends"

        // 내 친구 추가
        fromDocRef.getDocument { (document, error) in
            if let document = document, document.exists {
                var existingArray = document.data()?["\(fieldName)"] as? [String] ?? []
                
                // 배열에 새로운 값 추가
                if let _ = existingArray.filter({ $0 == code }).first {
                    self.isValidFailed = true
                    if let handler = completion {
                        handler()
                    }
                    return
                }
                existingArray.append(code)
                
                // 업데이트된 배열을 다시 문서에 저장
                fromDocRef.updateData([
                    "\(fieldName)": existingArray
                ]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                        self.isFailed = true
                    } else {
                        print("Document successfully updated")
                        DispatchQueue.main.async {
                            // 상대방이 나를 추가
                            toDocRef.getDocument { (document, error) in
                                if let document = document, document.exists {
                                    var existingArray = document.data()?["\(fieldName)"] as? [String] ?? []
                                    
                                    existingArray.append(uid)
                                    
                                    toDocRef.updateData([
                                        "\(fieldName)": existingArray
                                    ]) { err in
                                        if let err = err {
                                            print("Error updating document: \(err)")
                                            self.isFailed = true
                                        } else {
                                            print("Document successfully updated")
                                            self.isSuccess = true
                                            if let handler = completion {
                                                handler()
                                            }
                                        }
                                    }
                                } else {
                                    print("Document does not exist")
                                    self.isFailed = true
                                }
                            }
                        }
                        
                    }
                }
            } else {
                print("Document does not exist")
                self.isFailed = true
            }
        }
        
        
        
    }
}
