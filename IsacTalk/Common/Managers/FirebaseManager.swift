//
//  FirebaseManager.swift
//  IsacTalk
//
//  Created by 신이삭 on 2023/09/22.
//

import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import FirebaseMessaging

class FirebaseManager: NSObject {
    let auth: Auth
    let storage: Storage
    let firestore: Firestore
    let messaging: Messaging
    static let shared = FirebaseManager()
    
    override init() {
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        self.messaging = Messaging.messaging()
        super.init()
    }

}

