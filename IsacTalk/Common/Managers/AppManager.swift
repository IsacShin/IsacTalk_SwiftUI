//
//  AppManager.swift
//  IsacTalk
//
//  Created by 신이삭 on 2023/09/18.
//

import Foundation
import Combine
import SwiftUI

struct AppManager {
    static var subscriptions = Set<AnyCancellable>()

    static let isLogin = PassthroughSubject<Bool, Never>()
    static var loginUser: ChatUser?

    static func isLoggedIn() -> Bool {
        return FirebaseManager.shared.auth.currentUser != nil
    }
    
    static func logout(completion: (() -> Void)?) {
        try! FirebaseManager.shared.auth.signOut()
        AppManager.isLogin.send(false)
        
    }
    
    static func removeId(completion: (() -> Void)?) {
        FirebaseManager.shared.auth.currentUser?.delete(completion: { err in
            if let err = err {
                print(err)
            }
            guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
            FirebaseManager.shared.firestore.collection("users").document(uid).delete()
            try! FirebaseManager.shared.auth.signOut()
            AppManager.isLogin.send(false)
            
            if let completion = completion {
                completion()
            }
        })
    }
}

