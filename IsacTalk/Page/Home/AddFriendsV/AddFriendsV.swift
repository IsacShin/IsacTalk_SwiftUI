//
//  AddFriendsV.swift
//  IsacTalk
//
//  Created by 신이삭 on 2023/09/24.
//

import SwiftUI
import CustomTextField

struct AddFriendsV: View {
    @State var code: String = ""
    @ObservedObject private var keyboardManager = KeyboardManager()
    @State private var keyboardStatus: KeyboardManager.Status = .hide
    @Binding var isShowPlusFriends: Bool
    @State var showAlert = false
    @State private var alertType: AlertType = .isEmptyCode
    @State private var item: ActivityItem?
    @ObservedObject var vm = AddFriendsVM()
    @State var isLoading: Bool = false

    var body: some View {
        ZStack(alignment: .center) {
            Color.black.opacity(0.8)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Text("친구추가")
                        .foregroundColor(.white)
                    Spacer()
                    Button {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            self.isShowPlusFriends.toggle()
                        }
                    } label: {
                        Image("close")
                            .resizable()
                            .frame(width: 18, height: 18)
                    }

                }
                .padding()
                .background(MAIN_COLOR)
                
                Spacer().frame(height: 40)
                Text("원하는 사람에게 코드를 전송하거나\n코드를 입력해 친구를 추가해 보세요.")
                Spacer().frame(height: 20)
                EGTextField(text: $code)
                    .setPlaceHolderText("코드 입력")
                    .padding(.horizontal, 20)
                Spacer().frame(height: 20)
                HStack {
                    Button {
                        guard let code = AppManager.loginUser?.uid else { return }
                        
                        item = ActivityItem(
                            items: "[이삭톡] 코드를 추가해 친구가 되어보세요! \n\n\(code)"
                        )
                    } label: {
                        Text("코드 전송")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(MAIN_COLOR)
                    }
                    .activitySheet($item) { (type, completed, items, error) in
                        if completed == true {
                            self.alertType = .codeShareSuccess
                            self.showAlert.toggle()
                        } else {
                            print("공유 실패")
                        }
                    }

                    Button {
                        if code == "" {
                            self.alertType = .isEmptyCode
                            self.showAlert.toggle()
                        } else {
                            guard let uid = AppManager.loginUser?.uid else { return }
                            
                            if uid == code {
                                self.alertType = .addFriendsFailed
                                self.showAlert.toggle()
                            } else {
                                self.isLoading =  true
                                self.vm.storeUserFriends(code: code) {
                                    self.isLoading =  false
                                }
                            }
                        }
                    } label: {
                        Text("확인")
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 25)
                            .background(MAIN_COLOR)
                    }

                }
                Spacer().frame(height: 20)
                    
                
            }
            .background(Color.white)
            .padding()
            
            if isLoading {
                CommonLoadingV()
            }
        }
        .onReceive(self.keyboardManager.updateKeyboardStatus) { updatedStatus in
            self.keyboardStatus = updatedStatus
            print("높이: \(keyboardManager.keyboardHeight)")
        }
        .onReceive(vm.$isSuccess) { isSuccess in
            self.alertType = .addFriendsSuccess
            self.showAlert = isSuccess
        }
        .onReceive(vm.$isFailed) { isFailed in
            self.alertType = .isJoinFailed
            self.showAlert = isFailed
        }
        .onReceive(vm.$isValidFailed) { isFailed in
            self.alertType = .isValidFailed
            self.showAlert = isFailed
            self.code = ""
        }
        .onTapGesture {
            self.endEditing(true)
        }
        .alert(isPresented: self.$showAlert) {
            var msg: String = ""
            
            if self.alertType == .isEmptyCode {
                msg = AlertType.isEmptyCode.rawValue
            } else if self.alertType == .codeShareSuccess {
                msg = AlertType.codeShareSuccess.rawValue
            } else if self.alertType == .addFriendsSuccess {
                msg = AlertType.addFriendsSuccess.rawValue
            } else if self.alertType == .isJoinFailed {
                msg = AlertType.isJoinFailed.rawValue
            } else if self.alertType == .addFriendsFailed {
                msg = AlertType.addFriendsFailed.rawValue
            } else if self.alertType == .isValidFailed {
                msg = AlertType.isValidFailed.rawValue
            }
            
            return Alert(title: Text(msg), dismissButton: .default(Text("확인"), action: {
                if self.alertType == .codeShareSuccess || self.alertType == .addFriendsSuccess{
                    self.isShowPlusFriends = false
                }
            }))
        }
        
    }
}

struct AddFriendsV_Previews: PreviewProvider {
    static var previews: some View {
        AddFriendsV(isShowPlusFriends: .constant(true))
    }
}
