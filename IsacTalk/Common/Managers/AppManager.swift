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
    
    static func isLoggedIn() -> Bool {
        return UDF.string(forKey: "idToken") != nil
    }
    
    static func logout(completion: (() -> Void)?) {
        UDF.removeObject(forKey: "idToken")
        UDF.removeObject(forKey: "userName")
        UDF.removeObject(forKey: "memId")
        UDF.removeObject(forKey: "profileImg")
        AppManager.isLogin.send(false)
        
        if let completion = completion {
            completion()
        }
    }
    
    static func removeId(id: String, completion: (() -> Void)?) {
        
    }
}

