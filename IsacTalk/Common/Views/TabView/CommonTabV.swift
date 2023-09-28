//
//  CommonTabV.swift
//  IsacTalk
//
//  Created by 신이삭 on 2023/09/18.
//

import SwiftUI
import Hex

enum TabType {
    case HOME, MYPAGE
}

struct CommonTabV: View {
    init() {
        UITabBar.appearance().unselectedItemTintColor = .lightGray
        UITabBar.appearance().tintColor = UIColor(hex: "48CFAD")
        UITabBar.appearance().backgroundColor = UIColor.white
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().isTranslucent = true
    }
    
    @State var selectTab: TabType = .HOME
    @State var isLogin = AppManager.isLoggedIn()
    
    var body: some View {
        if isLogin {
            if #available(iOS 16.0, *) {
                NavigationStack {
                    tabV
                }
            } else {
                NavigationView {
                    tabV
                }
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
    
    private var tabV: some View {
        TabView(selection: $selectTab) {
            HomeV()
                .tabItem {
                    Image(systemName: "person.3")
                    Text("Home")
                }
                .tag(TabType.HOME)

            MyPageV(selectTab: $selectTab)
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("My")
                }
                .tag(TabType.MYPAGE)

        }
        .accentColor(MAIN_COLOR)
        .onReceive(AppManager.isLogin) {
            isLogin = $0
        }
    }
}

struct CommonTabV_Previews: PreviewProvider {
    static var previews: some View {
        CommonTabV()
    }
}
