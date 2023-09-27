//
//  HomeV.swift
//  IsacTalk
//
//  Created by 신이삭 on 2023/09/23.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase
import FirebaseFirestoreSwift

struct HomeV: View {
    @State var isShowPlusFriends = false
    @State var shouldShowNewMsgScreen = false
    @State var chatUser: ChatUser?
    @State var shouldNaviToChatLogView = false
    @ObservedObject private var vm = HomeVM()
    private var chatLogVM = ChatLogVM(chatUser: nil)
    @State var showAlert: Bool = false
    @State var alertType: AlertType = .loginOutConfirm
    
    @State var deleteToId: String?
    
    var body: some View {
        
        if #available(iOS 16.0, *) {
            NavigationStack {
                mainMessageView
            }
            .navigationDestination(isPresented: $shouldNaviToChatLogView) {
                ChatLogV(vm: chatLogVM)
            }
            
        } else {
            NavigationView {
                mainMessageView
            }
        }
        
    }
    
    private var mainMessageView: some View {
        ZStack(alignment: .top) {
            GeometryReader { g in
                MAIN_COLOR
                    .frame(height: g.safeAreaInsets.top, alignment: .top)
                    .ignoresSafeArea()
            }
            
            VStack(spacing: 0) {
                // 커스텀 네비바
                customNavBar
                messageView
                NavigationLink("", destination: ChatLogV(vm: chatLogVM), isActive: $shouldNaviToChatLogView)
                
            }
            .overlay(
                newMessageButton
                    .offset(y: -10)
                ,alignment: .bottom)
            .navigationBarHidden(true)
            
            if isShowPlusFriends {
                AddFriendsV(isShowPlusFriends: $isShowPlusFriends)
            }
        }
        .onAppear {
            vm.fetchRecentMessage()
        }
    }
    
    private var newMessageButton: some View {
        Button {
            shouldShowNewMsgScreen.toggle()
        } label: {
            HStack {
                Spacer()
                Text("새로운 대화")
                    .font(.system(size: 16, weight: .bold))
                Spacer()
            }
            .foregroundColor(.white)
            .padding(.vertical)
            .background(MAIN_COLOR)
            .cornerRadius(32)
            .padding(.horizontal)
            .shadow(radius: 15)
        }
        .fullScreenCover(isPresented: $shouldShowNewMsgScreen) {
            CreateNewMessageV(didSelectNewUser: { user in
                print(user.email)
                self.shouldNaviToChatLogView.toggle()
                self.chatUser = user
                self.chatLogVM.chatUser = user
                self.chatLogVM.fetchMessages()
            })
        }
        
    }
    
    private var customNavBar: some View {
        HStack(spacing: 16) {
            
            WebImage(url: URL(string: vm.chatUser?.profileImageUrl ?? ""))
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipped()
                .cornerRadius(50)
                .overlay(Circle().stroke(style: StrokeStyle(lineWidth: 1)).foregroundColor(.white))
                .shadow(radius: 5)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(vm.chatUser?.name ?? "")")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                HStack {
                    Circle()
                        .foregroundColor(.green)
                        .frame(width: 14, height: 14)
                    Text("online")
                        .font(.system(size: 12))
                        .foregroundColor(Color.white)
                }
            }
            
            Spacer()
            Button {
                GADInterstitial.shared.loadFullAd()
                withAnimation(.easeInOut(duration: 0.25)) {
                    self.isShowPlusFriends.toggle()
                }
            } label: {
                VStack {
                    Image(systemName: "person.badge.plus")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color.white)
                    Spacer().frame(height: 4)
                    Text("친구추가")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                }
            }
            
        }
        .padding()
        .background(MAIN_COLOR)
        
    }
    
    private var messageView: some View {
        GeometryReader { g in
            if vm.recentMessages.count > 0 {
                List {
                    ForEach(vm.recentMessages) { recentMsg in
                        VStack(alignment: .leading, spacing: 0) {
                            Spacer().frame(height: 5)
                            Button {
                                let uid = FirebaseManager.shared.auth.currentUser?.uid == recentMsg.fromId ? recentMsg.toId : recentMsg.fromId
                                self.chatUser = .init(data: [
                                    FirebaseContants.email: recentMsg.email,
                                    FirebaseContants.name: recentMsg.name,
                                    FirebaseContants.profileImageUrl: recentMsg.profileImageUrl,
                                    "uid": uid,
                                    FirebaseContants.pushToken: recentMsg.pushToken
                                ])
                                self.chatLogVM.chatUser = self.chatUser
                                self.chatLogVM.fetchMessages()
                                self.shouldNaviToChatLogView.toggle()
                            } label: {
                                HStack {
                                    WebImage(url: URL(string: recentMsg.profileImageUrl))
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 54, height: 54)
                                        .clipped()
                                        .cornerRadius(54)
                                        .overlay(Circle().stroke(style: StrokeStyle(lineWidth: 1)))
                                        .foregroundColor(.black)

                                    Spacer().frame(width: 15)
                                    VStack(alignment: .leading) {
                                        Text(recentMsg.name)
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(Color(.label))
                                            .multilineTextAlignment(.leading)
                                        Spacer().frame(height: 5)
                                        Text(recentMsg.text)
                                            .lineLimit(2)
                                            .font(.system(size: 14))
                                            .foregroundColor(Color(.lightGray))
                                            .multilineTextAlignment(.leading)
                                    }
                                    Spacer()
                                    Text(recentMsg.timeAgo)
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(Color(.label))
                                }
                            }
                            Spacer().frame(height: 5)
                            Divider()
                                .frame(height: 0.5)
                                .background(Color.black)
                                .padding(.vertical, 8)
                                
                                
                        }
                        .listRowInsets(.init(top: 8, leading: 1, bottom: -8, trailing: 1))

                    }
                    .onDelete(perform: { offsets in
                        if let firstIndex = offsets.first {
                            let toId = vm.recentMessages[firstIndex].toId
                            self.deleteToId = toId
                            self.alertType = .chatDeleteConfirm
                            self.showAlert.toggle()
                        }
                    })

                }
                .listStyle(PlainListStyle())
                .alert(isPresented: $showAlert) {
                    return Alert(title: Text(alertType.rawValue), primaryButton: .default(Text("확인"), action: {
                        guard let toId = self.deleteToId else { return }
                        self.vm.deleteMessage(toId: toId)
                    }), secondaryButton: .cancel(Text("취소")))
                }
                .padding(.horizontal)
                
            } else {
                VStack(alignment: .center) {
                    Spacer()
                    Text("진행중인 대화방이 없습니다.")
                    Spacer()
                }
                .offset(y: -40)
                .frame(minWidth: g.size.width, minHeight: g.size.height)
            }
        }
        
    }
    
}

struct HomeV_Previews: PreviewProvider {
    static var previews: some View {
        HomeV()
    }
}
