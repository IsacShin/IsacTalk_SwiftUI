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
                }
                
                ScrollView {
                    Text(vm.errorMsg)
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
                                Text(user.email)
                                    .foregroundColor(Color(.label))
                                Spacer()
                            }
                            .padding(.horizontal)
                        }

                        
                        Divider()
                            .padding(8)
                    }
                }
            }
            
            .navigationTitle("친구 목록")
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
