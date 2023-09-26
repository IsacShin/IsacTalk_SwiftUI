//
//  CreateNewMessageV.swift
//  IsacTalk
//
//  Created by 신이삭 on 2023/09/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct CreateNewMessageV: View {
    
    var didSelectNewUser: (ChatUser) -> ()
      
    @Environment(\.dismiss) var dismiss
    @ObservedObject var vm = CreateNewMessageVM()
    
    init(didSelectNewUser: @escaping (ChatUser) -> ()) {
        self.didSelectNewUser = didSelectNewUser
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().barTintColor = UIColor(hex: "48CFAD")
    }
    
    var body: some View {

        NavigationView {
            ZStack(alignment: .top) {
                GeometryReader { g in
                    MAIN_COLOR
                        .frame(height: g.safeAreaInsets.top, alignment: .top)
                        .ignoresSafeArea()
                    
                    if vm.users.count > 0 {
                        ScrollView {
                            VStack {
                                Spacer().frame(height: 20)
                                ForEach(vm.users) { user in
                                    Button {
                                        dismiss()
                                        didSelectNewUser(user)
                                    } label: {
                                        HStack(spacing: 16) {
                                            WebImage(url: URL(string: user.profileImageUrl))
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 50, height: 50)
                                                .clipped()
                                                .cornerRadius(50)
                                                .overlay(Circle().stroke(style: .init(lineWidth: 2)).foregroundColor(Color(.label)))
                                            Text("\(user.name)(\(user.email))")
                                                .multilineTextAlignment(.leading)
                                                .font(.system(size: 18))
                                                .foregroundColor(.black)
                                            Spacer()
                                        }
                                        .padding(.horizontal)
                                    }

                                    
                                    Divider()
                                        .padding(8)
                                }
                            }
                            
                        }
                    } else {
                        VStack(alignment: .center) {
                            Spacer()
                            Text("코드전송을 통해 친구를 추가 해보세요")
                                .font(.system(size: 17))
                            Spacer()
                        }
                        .offset(y: -40)
                        .frame(minWidth: g.size.width, minHeight: g.size.height)
                    }
                    
                }
                
                
            }
            .navigationTitle("친구 목록")
            .navigationBarHidden(false)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("닫기")
                            .foregroundColor(.white)
                    }

                }
            }
        }
    }
}

struct CreateNewMessageV_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewMessageV(didSelectNewUser: { user in
            print(user.email)
        })
    }
}
