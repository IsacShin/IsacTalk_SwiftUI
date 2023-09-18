//
//  NaviManager.swift
//  IsacTalk
//
//  Created by 신이삭 on 2023/09/18.
//

import Foundation
import SwiftUI

struct NaviManager {
    static func popToRootView(completion: (() -> Void)? = nil) {
        let keyWindow = WINDOW
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        findNavigationController(viewController: keyWindow?.rootViewController)?
            .popToRootViewController(animated: true)
        CATransaction.commit()
        
    }
    
    static func popViewController(handler: () -> Void ,completion: @escaping () -> Void) {
        
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        
        handler()
        
        CATransaction.commit()
    }
    
    static func findNavigationController(viewController: UIViewController?) -> UINavigationController? {
        guard let viewController = viewController else {
            return nil
        }
        
        if let navigationController = viewController as? UINavigationController {
            return navigationController
        }
        
        for childViewController in viewController.children {
            return findNavigationController(viewController: childViewController)
        }
        
        return nil
    }
}
