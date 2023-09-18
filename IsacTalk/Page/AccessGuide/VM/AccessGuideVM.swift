//
//  AccessGuideVM.swift
//  IsacTalk
//
//  Created by 신이삭 on 2023/09/18.
//

import Foundation
import CoreLocation
import Combine
import SwiftUI
import Photos

class AccessGuideVM: ObservableObject {
    var success = CurrentValueSubject<Bool, Never>.init(false)
}

extension AccessGuideVM {
    func showCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
            if granted {
                print("Camera: 권한 허용")
            } else {
                print("Camera: 권한 거부")
            }
            self.showPhotoPermission(completion: {
                DispatchQueue.main.async {
                    self.success.send(true)
                }
            })
        })
    }
    
    
    func showPhotoPermission(completion: (() -> Void)? = nil) {
        
        if #available(iOS 14, *) {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { _ in
                completion?()
            }
        } else {
            PHPhotoLibrary.requestAuthorization { _ in
                completion?()
            }
        }
    }
    
}

