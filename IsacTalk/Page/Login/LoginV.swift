//
//  LoginV.swift
//  IsacTalk
//
//  Created by 신이삭 on 2023/09/21.
//

import SwiftUI

struct LoginV: View {
    @ObservedObject var vm = LoginVM()
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Spacer().frame(height: 130)
                Image("LOGO")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .offset(y: 20)
                Text("간편하게 즐기는 1대1 채팅")
                    .font(.system(size: 17))
                    .foregroundColor(.white)
                Spacer()
                
                NavigationLink {
                    idLoginV(vm: vm)
                } label: {
                    Text("로그인")
                        .font(.system(size: 17))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(Color.white)
                        .padding(.horizontal, 20)
                }

                Spacer().frame(height: 10)
                
                NavigationLink {
                    JoinV()
                } label: {
                    Text("회원가입")
                        .font(.system(size: 17))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(Color.white)
                        .padding(.horizontal, 20)
                }

                Spacer().frame(height: 70)
            }
            .background(MAIN_COLOR)
            .edgesIgnoringSafeArea(.all)
        }
        .onReceive(AppManager.isLogin) {
            if $0 {
                presentationMode.wrappedValue.dismiss() // 이미 로그인되었으면 로그인 뷰 닫기
            }
        }
    }
}

struct LoginV_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([DeviceType.iPhone_SE_3rd_generation.rawValue, DeviceType.iPhone_13_Pro.rawValue], id: \.self) { (deviceName)  in
            
            LoginV().previewDevice(PreviewDevice(rawValue: deviceName))
        }
    }
}
