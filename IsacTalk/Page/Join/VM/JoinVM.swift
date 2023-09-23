//
//  JoinVM.swift
//  IsacTalk
//
//  Created by 신이삭 on 2023/09/22.
//

import Foundation
import SwiftUI
import Combine

class JoinVM: ObservableObject {
    var subscriptions = Set<AnyCancellable>()
    var nameCheck = PassthroughSubject<Bool, Never>()
    var emailCheck = PassthroughSubject<Bool, Never>()
    var pwdCheck = PassthroughSubject<Bool, Never>()
    var pwdConfirmCheck = PassthroughSubject<Bool, Never>()

    var isValidCheckPublisher: AnyPublisher<(Bool, Bool, Bool, Bool), Never> {
        emailCheck.combineLatest(pwdCheck, pwdConfirmCheck, nameCheck)
            .eraseToAnyPublisher()
    }
    
    @Published var isJoinFailed: Bool = false
    @Published var isJoinedAlert: Bool = false
    @Published var isSuccess: Bool = false
    
    func regist(fileImg: UIImage? = nil, info: [String: Any], completion: @escaping () -> Void) {
        guard let email = info["email"] as? String,
              let password = info["password"] as? String else { return }
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) {
            result, err in
            if let err = err {
                print("Failed to create User", err)
                self.isJoinFailed = true
                return
            }
            
            print("Successfully created user: \(result?.user.uid ?? "")")
            self.persistImageToStorage(fileImg: fileImg, info: info, completion: completion)
        }
    }
    
    private func persistImageToStorage(fileImg: UIImage? = nil, info: [String: Any], completion: @escaping () -> Void) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        let ref = FirebaseManager.shared.storage.reference(withPath: "users/" + uid)
        
        guard let imageData = fileImg?.jpegData(compressionQuality: 0.1) else { return }
        ref.putData(imageData) { metaData, err in
            if let err = err {
                print(err.localizedDescription)
                AppManager.logout {
                    self.isJoinFailed = true
                }
                return
            }
            
            ref.downloadURL { url, err in
                if let err = err {
                    print(err.localizedDescription)
                    AppManager.logout {
                        self.isJoinFailed = true
                    }
                    return
                }
                
                print("Successfully stored image with url: \(url?.absoluteString ?? "")")
                guard let url = url else { return }
                self.storeUserInfo(profileImgUrl: url, info: info, completion: completion)
            }
        }
    }
    
    private func storeUserInfo(profileImgUrl: URL, info: [String: Any], completion: @escaping () -> Void) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid,
              let email = info["email"] as? String,
              let name = info["name"] as? String else { return }
        
        FirebaseManager.shared.messaging.token { result, error in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
                AppManager.logout {
                    self.isJoinFailed = true
                }
            } else if let result = result {
                print("Remote instance ID token: \(result)")
                let userData = [
                    "email": email,
                    "name" : name,
                    "uid": uid,
                    "profileImageUrl": profileImgUrl.absoluteString,
                    "friends": [],
                    "pushToken": result
                ] as [String: Any]

                FirebaseManager.shared.firestore.collection("users")
                    .document(uid).setData(userData) { err in
                        if let err = err {
                            print(err)
                            AppManager.logout {
                                self.isJoinFailed = true
                            }
                            return
                        }
                        
                        print("Success")
                        self.isSuccess = true
                        completion()
                    }
            }
        }
        
        
    }
    
    
}
