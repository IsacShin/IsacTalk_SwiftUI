//
//  LoginVM.swift
//  IsacTalk
//
//  Created by 신이삭 on 2023/09/21.
//

import Foundation
import SwiftUI
import Combine

class LoginVM: ObservableObject {
    var subscriptions = Set<AnyCancellable>()
    var idCheck = PassthroughSubject<Bool, Never>()
    var pwdCheck = PassthroughSubject<Bool, Never>()
    
    @Published var isLoginFailed: Bool = false
    
    var isValidPublisher: AnyPublisher<(Bool, Bool), Never> {
        idCheck.combineLatest(pwdCheck)
            .eraseToAnyPublisher()
    }
    
    func idLogin(id: String?, password: String?, completion: @escaping () -> Void) {
        guard let id = id, let password = password else { return }
        
        FirebaseManager.shared.auth.signIn(withEmail: id, password: password) {
            result, err in
            if let err = err {
                print("Failed to login User", err)
                self.isLoginFailed = true
                return
            }
            
            print("Successfully login user: \(result?.user.uid ?? "")")
            self.fetchCurrentUser()
        }
        
    }
    
    private func fetchCurrentUser() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            return
        }

        FirebaseManager.shared.firestore.collection("users")
            .document(uid).getDocument { snapshot, err in
                if let err = err {
                    print("Failed to fetch current user:", err)
                }
                
                guard let data = snapshot?.data() else {
                    return
                }
                self.isLoginFailed = false

                AppManager.loginUser = .init(data: data)
                AppManager.isLogin.send(true)

            }
    }
    
}
