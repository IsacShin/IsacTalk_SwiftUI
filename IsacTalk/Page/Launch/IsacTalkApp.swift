//
//  IsacTalkApp.swift
//  IsacTalk
//
//  Created by 신이삭 on 2023/09/18.
//

import SwiftUI

enum RootViewType {
    case Splash
    case CommonTabView
}

final class AppVM: ObservableObject {
    @Published var rootViewId: RootViewType = .Splash
}

@main
struct IsacTalkApp: App {
    @ObservedObject var vm = AppVM()
    
    var body: some Scene {
        WindowGroup {
            if vm.rootViewId == .Splash {
                SplashV()
                    .id(vm.rootViewId)
                    .environmentObject(vm)
                    .sizeCategory(.small)
            } else {
                CommonTabV()
                    .id(vm.rootViewId)
                    .environmentObject(vm)
                    .sizeCategory(.small)
            }
        }
    }
}
