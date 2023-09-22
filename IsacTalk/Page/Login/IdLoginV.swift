//
//  IdLoginV.swift
//  IsacTalk
//
//  Created by 신이삭 on 2023/09/21.
//

import SwiftUI
import CustomTextField
import Hex

struct idLoginV: View {
    
    init(vm: LoginVM) {
        self.vm = vm

        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = UIColor(hex: "48CFAD")
    }
    
    @State private var id: String = ""
    @State private var password: String = ""
    @State private var isValid: Bool = false
    @State private var keyboardStatus: KeyboardManager.Status = .hide
    @State private var isLoginFailed: Bool = false
    
    @EnvironmentObject private var appVM: AppVM
    @ObservedObject private var keyboardManager = KeyboardManager()
    @ObservedObject private var vm: LoginVM

    var body: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    Spacer()
                   
                    EGTextField(text: $id)
                        .setPlaceHolderText("아이디")
                        .setPlaceHolderTextColor(.white)
                        .setTextColor(.white)
                        .setBorderColor(.white)
                        .setBackgroundColor(MAIN_COLOR)
                        .setBorderType(.line)
                        .padding(.horizontal, 20)
                        .onChange(of: id, perform: { newValue in
                            if id.count > 20  {
                                id = String(newValue.prefix(20))
                            } else {
                                if newValue.count > 3 {
                                    self.vm.idCheck.send(true)
                                } else {
                                    self.vm.idCheck.send(false)
                                }
                            }
                        })
                    
                    Spacer().frame(height: 12)
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
                    
                    Button {
                        self.vm.idLogin(id: id, password: password) {
                            NaviManager.popToRootView {
                                withAnimation {
                                    appVM.rootViewId = .CommonTabView
                                }
                            }
                        }
                    } label: {
                        Text("로그인")
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                            .background(isValid ? .init(white: 0, opacity: 0.75) : Color.gray)
                            .cornerRadius(16)
                            .padding(20)

                    }
                    .disabled(!isValid)
                    
                    Spacer()
                }
                
                .background(MAIN_COLOR)
                .frame(minHeight: geometry.size.height)
                
            }
            .background(MAIN_COLOR)
            
            .onReceive(self.keyboardManager.updateKeyboardStatus) { updatedStatus in
                self.keyboardStatus = updatedStatus
                print("높이: \(keyboardManager.keyboardHeight)")
            }
            .onReceive(vm.$isLoginFailed) { isLoginFailed in
                self.isLoginFailed = isLoginFailed
            }
            .onTapGesture {
                self.endEditing(true)
            }
            .alert(isPresented: self.$isLoginFailed) {
                Alert(title: Text("아이디 또는 비밀번호를 확인해주세요."), dismissButton: .default(Text("확인"), action: {
                    print("버튼 클릭")
                }))
            }
            
            .navigationTitle("로그인")
        }
        .edgesIgnoringSafeArea(.all)

        .background(MAIN_COLOR)
        .onAppear {
            vm.isValidPublisher
                .sink { value1, value2 in
                    print("Combined Values: \(value1), \(value2)")
                    if value1 && value2 {
                        isValid = true
                    } else {
                        isValid = false
                    }
                }
                .store(in: &vm.subscriptions)
        }
        
    }
}

struct idLoginV_Previews: PreviewProvider {
    static var previews: some View {
        idLoginV(vm: LoginVM())
    }
}
