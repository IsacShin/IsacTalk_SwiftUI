//
//  CommonTabV.swift
//  IsacTalk
//
//  Created by 신이삭 on 2023/09/18.
//

import SwiftUI

enum TabType {
    case HOME, MYPAGE
}

struct CommonTabV: View {
    init() {
        UITabBar.appearance().unselectedItemTintColor = .lightGray
        UITabBar.appearance().backgroundColor = UIColor.white
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().isTranslucent = true
    }
    
    @State var selectTab: TabType = .HOME
    @State var isLogin = AppManager.isLoggedIn()
    
    var body: some View {
        if isLogin {
            TabView(selection: $selectTab) {
                Text("Home")
                    .tabItem {
                        Image(systemName: "map")
                        Text("Home")
                    }
                    .tag(TabType.HOME)

                Text("My")
                    .tabItem {
                        Image(systemName: "list.bullet.below.rectangle")
                        Text("My")
                    }
                    .tag(TabType.MYPAGE)

            }            
            .onReceive(AppManager.isLogin) {
                isLogin = $0
            }
        } else {
            withAnimation {
                LoginV()
                    .transition(.move(edge: .bottom))
                    .onReceive(AppManager.isLogin) {
                        isLogin = $0
                    }
            }
        }
    }
}

struct CommonTabV_Previews: PreviewProvider {
    static var previews: some View {
        CommonTabV()
    }
}
