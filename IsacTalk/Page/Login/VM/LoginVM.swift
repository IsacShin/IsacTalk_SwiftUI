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
        
//        LoginApiService.getMember(id: id, password: password)
//            .sink { complete in
//                print("LoginVM completion: \(complete)")
//                switch complete {
//                case .finished:
//                    print("LoginVM completion: finished")
//                    
//                case .failure(let error):
//                    print("LoginVM completion: failure(\(error))")
//                    self.isLoginFailed = true
//                }
//            } receiveValue: { members in
//                guard let member = members.list?.first else {
//                    self.isLoginFailed = true
//                    return
//                }
//                
//                self.loginUser = member
//                AppManager.loginUser = self.loginUser
//                
//                self.loginSuccess(
//                    token: "\(member.uuid)",
//                    name: member.name,
//                    id: member.memid
//                )
//                
//                self.isLoginFailed = false
//                completion()
//            }
//            .store(in: &subscriptions)
        
    }
    
    
    private func loginSuccess(token: String?, name: String?, id: String?) {
        guard let token = token,
              let name = name,
              let id = id else { return }

        UDF.setValue(token, forKey: "idToken")
        UDF.setValue(id, forKey: "memId")
        UDF.setValue(name, forKey: "userName")
        
//        if let pImg = self.loginUser?.profileUrl {
//            UDF.set(pImg, forKey: "profileImg")
//        }
        
        AppManager.isLogin.send(true)
        
    }
    
}
