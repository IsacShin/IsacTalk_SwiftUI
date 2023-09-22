//
//  SplashVM.swift
//  IsacTalk
//
//  Created by 신이삭 on 2023/09/18.
//

import Foundation
import Combine

enum LaunchState {
    case first, yet
}

class SplashVM: ObservableObject {
    var nextAction = PassthroughSubject<LaunchState, Never>()
    
    func startLaunch() {
//        AppManager.logout(completion: nil)
        if UDF.bool(forKey: "firstLaunch") {
            self.nextAction.send(.yet)
        } else {
            self.nextAction.send(.first)
        }
    }
}
