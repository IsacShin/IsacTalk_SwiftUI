//
//  ChatLogV.swift
//  IsacTalk
//
//  Created by 신이삭 on 2023/09/25.
//

import SwiftUI
import HidableTabView
import SDWebImageSwiftUI

struct ChatLogV: View {

    @ObservedObject var vm: ChatLogVM
    @State var keyboardStatus: KeyboardManager.Status = .hide
    @ObservedObject var keyboardManager = KeyboardManager()
    @State var showPhotoPicker: Bool = false
    
    init(vm: ChatLogVM) {
        self.vm = vm
        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = UIColor(hex: "48CFAD")
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        ZStack {
            messageView
            VStack(spacing: 0) {
                Spacer()
                chatBottomBar
            }
        }
        .onTapGesture {
            self.endEditing(true)
        }
        .navigationTitle(vm.chatUser?.name ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            UITabBar.hideTabBar(animated: false)
        }
        .onDisappear {
            UITabBar.showTabBar(animated: true)
            // 리스너 순환참조 방지
            vm.firestoreListener?.remove()
        }
    }
    
    private var messageView: some View {
        ScrollView {
            ScrollViewReader { scrollViewProxy in
                VStack {
                    ForEach(vm.chatMessages) { message in
                        VStack {
                            Spacer().frame(height: 8)
                            if message.fromId == FirebaseManager.shared.auth.currentUser?.uid {
                                if message.img == "" {
                                    HStack {
                                        Spacer()
                                        VStack {
                                            Spacer()
                                            Text(message.timestamp.formattedDate())
                                                .foregroundColor(.white)
                                                .font(.system(size: 11))
                                        }
                                        HStack {
                                            Text(message.text)
                                                .foregroundColor(.black)
                                        }
                                        .padding()
                                        .background(Color.init(red: 255/255, green: 228/255, blue: 1/255))
                                        .cornerRadius(8)
                                    }
                                    

                                } else {
                                    HStack {
                                        Spacer()
                                        VStack {
                                            Spacer()
                                            Text(message.timestamp.formattedDate())
                                                .foregroundColor(.white)
                                                .font(.system(size: 11))
                                        }
                                        HStack {
                                            WebImage(url: URL(string: message.img))
                                                .resizable()
                                                .scaledToFill()
                                                .frame(maxWidth: SCREEN_WIDTH - 100, maxHeight: 350)
                                        }
                                        .background(Color.init(red: 255/255, green: 228/255, blue: 1/255))
                                        .cornerRadius(8)
                                    }
                                    
                                }
                                
                            } else {
                                if message.img == "" {
                                    HStack {
                                        HStack {
                                            Text(message.text)
                                                .foregroundColor(.black)
                                        }
                                        .padding()
                                        .background(Color.init(red: 213/255, green: 213/255, blue: 213/255))
                                        .cornerRadius(8)
                                        VStack {
                                            Spacer()
                                            Text(message.timestamp.formattedDate())
                                                .foregroundColor(.white)
                                                .font(.system(size: 11))
                                        }
                                        Spacer()
                                    }
                                } else {
                                    HStack {
                                        HStack {
                                            WebImage(url: URL(string: message.img))
                                                .resizable()
                                                .scaledToFill()
                                                .frame(maxWidth: SCREEN_WIDTH - 100, maxHeight: 350)
                                        }
                                        .background(Color.init(red: 213/255, green: 213/255, blue: 213/255))
                                        .cornerRadius(8)
                                        VStack {
                                            Spacer()
                                            Text(message.timestamp.formattedDate())
                                                .foregroundColor(.white)
                                                .font(.system(size: 11))
                                        }
                                        Spacer()

                                    }
                                }
                                
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    HStack { Spacer() }
                        .id("Empty")
                }
                .onReceive(vm.$count) { _ in
                    withAnimation(.easeOut(duration: 0.5)) {
                        scrollViewProxy.scrollTo("Empty", anchor: .bottom)
                    }
                }
                .onReceive(self.keyboardManager.updateKeyboardStatus) { updatedStatus in
                    self.keyboardStatus = updatedStatus
                    print("높이: \(keyboardManager.keyboardHeight)")
                    if self.keyboardStatus == .show {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.vm.count += 1
                        }
                    }
                }
                .sheet(isPresented: $showPhotoPicker) {
                    CommonImagePicker(completion: { images in
                        guard let sendImg = images.first else { return }
                        self.vm.handleSend(sendImg: sendImg)
                    }, maxCount: 1)
                }
                
                    
            }
            
        }
        .background(MAIN_COLOR)
        .padding(.bottom, 65)
    }
    
    private struct DescriptionPlaceholder: View {
        var body: some View {
            HStack {
                Text("메세지를 입력하세요")
                    .foregroundColor(Color(.gray))
                    .font(.system(size: 17))
                    .padding(.leading, 5)
                    .padding(.top, -4)
                Spacer()
            }
        }
    }
    
    private var chatBottomBar: some View {
        HStack(spacing: 16) {
            Button {
                self.showPhotoPicker = true
            } label: {
                Image(systemName: "photo.on.rectangle")
                    .font(.system(size: 24))
                    .foregroundColor(Color(.darkGray))
            }
            
            ZStack {
                DescriptionPlaceholder()
                TextEditor(text: $vm.chatText)
                    .opacity(vm.chatText.isEmpty ? 0.5 : 1)
            }
            .frame(height: 40)
            Button {
                self.vm.handleSend(sendImg: nil)
            } label: {
                Text("전송")
                    .foregroundColor(.white)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(MAIN_COLOR)
            .cornerRadius(4)

        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color.white)

    }
}


struct ChatLogV_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatLogV(vm: ChatLogVM(chatUser: .init(data: [
                "uid": "KLULxP5qivSehbO5sbRAqo3CLGt1",
                "email": "isac9305@naver.com",
                "name": "신이삭"
            ])))
        }
    }
}
