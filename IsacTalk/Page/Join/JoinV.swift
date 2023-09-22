//
//  JoinV.swift
//  IsacTalk
//
//  Created by 신이삭 on 2023/09/22.
//

import SwiftUI
import CustomTextField
import Hex

struct JoinV: View {
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = UIColor(hex: "48CFAD")
    }
    
    @State private var profileImg: UIImage?
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var passwordCheck: String = ""
    @State private var isValid: Bool = false
    @State var keyboardStatus: KeyboardManager.Status = .hide
    @State var showAlert = false
    @State private var alertType: AlertType = .isJoinFailed
    @State var isLoading: Bool = false
    @State var showPhotoPicker: Bool = false

    @State var placeholder = "비밀번호 확인"
    @EnvironmentObject var appVM: AppVM
    @ObservedObject var keyboardManager = KeyboardManager()
    @ObservedObject var vm: JoinVM = JoinVM()

    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
                ScrollView(showsIndicators: false) {
                    
                    VStack(spacing: 0) {
                        Spacer()
                        
                        Group {
                            Spacer().frame(height: 50)
                            Button {
                                self.showPhotoPicker = true
                            } label: {
                                if let img = self.profileImg {
                                    Image(uiImage: img)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .clipShape(Circle())
                                        .frame(width: 100, height: 100)
                                        .overlay(Circle().stroke(Color.white, lineWidth: 3))
                                        .overlay(Image(systemName: "plus")
                                            .resizable()
                                            .frame(width: 35, height: 35)
                                            .foregroundColor(.white))
                                } else {
                                    Image("")
                                        .clipShape(Circle())
                                        .frame(width: 100, height: 100)
                                        .overlay (
                                            Circle().stroke(Color.white, lineWidth: 3)
                                        )
                                        .overlay (
                                            Image(systemName: "plus")
                                                .resizable()
                                                .frame(width: 35, height: 35)
                                                .foregroundColor(.white)
                                        )
                                }
                                
                            }

                            Spacer().frame(height: 30)
                            Text("프로필 이미지를 등록해주세요")
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        Group {
                            EGTextField(text: $name)
                                .setPlaceHolderText("이름")
                                .setPlaceHolderTextColor(.white)
                                .setTextColor(.white)
                                .setBorderColor(.white)
                                .setBackgroundColor(MAIN_COLOR)
                                .setBorderType(.line)
                                .padding(.horizontal, 20)
                                .onChange(of: name, perform: { newValue in
                                    if name.count > 10  {
                                        name = String(newValue.prefix(10))
                                    } else {
                                        if newValue.count > 1 {
                                            self.vm.nameCheck.send(true)
                                        } else {
                                            self.vm.nameCheck.send(false)
                                        }
                                    }
                                })
                            
                            Spacer().frame(height: 12)
                        }
                        
                        Group {
                            EGTextField(text: $email)
                                .setPlaceHolderText("이메일")
                                .setPlaceHolderTextColor(.white)
                                .setTextColor(.white)
                                .setBorderColor(.white)
                                .setBackgroundColor(MAIN_COLOR)
                                .setBorderType(.line)
                                .padding(.horizontal, 20)
                                
                                .onChange(of: email, perform: { newValue in
                                    if email.isValidEmail() {
                                        self.vm.emailCheck.send(true)
                                    } else {
                                        self.vm.emailCheck.send(false)
                                    }
                                })
                            
                            Spacer().frame(height: 12)
                        }
                        
                        Group {
                            EGTextField(text: $password)
                                .setSecureText(true)
                                .setPlaceHolderText("비밀번호")
                                .setPlaceHolderTextColor(.white)
                                .setTextColor(.white)
                                .setBorderColor(.white)
                                .setBackgroundColor(MAIN_COLOR)
                                .setBorderType(.line)
                                .padding(.horizontal, 20)
                                .onChange(of: password, perform: { newValue in
                                    if password.count > 20  {
                                        password = String(newValue.prefix(20))
                                    } else {
                                        if newValue.count > 3 {
                                            self.vm.pwdCheck.send(true)
                                        } else {
                                            self.vm.pwdCheck.send(false)
                                        }
                                    }
                                })
                            
                            Spacer().frame(height: 12)
                        }
                        
                        Group {
                            EGTextField(text: $passwordCheck)
                                .setSecureText(true)
                                .setPlaceHolderText("비밀번호 확인")
                                .setPlaceHolderTextColor(.white)
                                .setTextColor(.white)
                                .setBorderColor(.white)
                                .setBackgroundColor(MAIN_COLOR)
                                .setBorderType(.line)
                                .keyboardType(.alphabet)
                                .frame(height: 60)
                                .padding(.horizontal, 20)
                                .onChange(of: passwordCheck, perform: { newValue in
                                    if newValue != password {
                                        self.vm.pwdConfirmCheck.send(false)
                                        self.placeholder = "비밀번호를 확인해주세요."
                                    } else {
                                        self.vm.pwdConfirmCheck.send(true)
                                        self.placeholder = "비밀번호 확인"
                                    }
                                })
                            
                            Spacer().frame(height: 12)
                        }
                        
                        Spacer()

                        Button {
                            let info = [
                                "email" : self.email,
                                "name" : self.name,
                                "password" : self.password
                            ]
                            self.isLoading =  true
                            self.vm.regist(fileImg: self.profileImg,
                                           info: info) {
                                self.isLoading =  false
                                self.vm.isSuccess = true
                            }
                            
                        } label: {
                            Text("회원가입")
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                                .background(isValid ? .init(white: 0, opacity: 0.75) : Color.gray)
                                .cornerRadius(16)
                                .padding(20)

                        }
                        .disabled(!isValid)
                        
                        Spacer().frame(height: 45)
                        
                    }
                    
                    .background(MAIN_COLOR)
                    .frame(minHeight: geometry.size.height)
                }
                .background(MAIN_COLOR)
                .onReceive(self.keyboardManager.updateKeyboardStatus) { updatedStatus in
                    self.keyboardStatus = updatedStatus
                    print("높이: \(keyboardManager.keyboardHeight)")
                }
                .onReceive(vm.$isJoinFailed) { isJoinFailed in
                    self.alertType = .isJoinFailed
                    self.showAlert = isJoinFailed
                }
                .onReceive(vm.$isJoinedAlert) { isJoinedAlert in
                    self.alertType = .isJoinedAlert
                    self.showAlert = isJoinedAlert
                }
                .onReceive(vm.$isSuccess) { isSuccess in
                    self.alertType = .joinSuccess
                    self.showAlert = isSuccess
                }
                .onTapGesture {
                    self.endEditing(true)
                }
                .alert(isPresented: self.$showAlert) {
                    var msg: String = ""
                    
                    if self.alertType == .joinSuccess {
                        msg = AlertType.joinSuccess.rawValue
                    } else if self.alertType == .isJoinedAlert {
                        msg = AlertType.isJoinedAlert.rawValue
                    } else if self.alertType == .isJoinFailed {
                        msg = AlertType.isJoinFailed.rawValue
                    }
                    return Alert(title: Text(msg), dismissButton: .default(Text("확인"), action: {
                        NaviManager.popToRootView()
                    }))
                }
                .sheet(isPresented: $showPhotoPicker) {
                    CommonImagePicker(completion: { images in
                        guard let profileImg = images.first else { return }
                        self.profileImg = profileImg
                    }, maxCount: 1)
                }
                
                if isLoading {
                    CommonLoadingV()
                }
                
            }
            
            .navigationTitle("회원가입")
        }
        .edgesIgnoringSafeArea(.all)
        .background(MAIN_COLOR)
        
        .onAppear {
            vm.isValidCheckPublisher
                .eraseToAnyPublisher()
                .sink {
                    if $0.0 &&
                        $0.1 &&
                        $0.2 &&
                        $0.3 && self.profileImg != nil {
                        self.isValid = true
                    } else {
                        self.isValid = false
                    }
                }
                .store(in: &vm.subscriptions)

        }
        
    }
}

struct JoinV_Previews: PreviewProvider {
    static var previews: some View {
        JoinV()
    }
}
