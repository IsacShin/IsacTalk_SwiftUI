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
        if UDF.bool(forKey: "firstLaunch") {
            self.nextAction.send(.yet)
        } else {
            AppManager.logout(completion: nil)
            self.nextAction.send(.first)
        }
    }
}
