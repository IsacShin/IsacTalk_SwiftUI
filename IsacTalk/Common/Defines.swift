//
//  Defines.swift
//  IsacTalk
//
//  Created by 신이삭 on 2023/09/18.
//

import Foundation
import UIKit
import SwiftUI

// MARK: - SCREEN 관련
let WINDOW                  = UIApplication.getKeyWindow()
let SCREEN_WIDTH            = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT           = UIScreen.main.bounds.size.height

// MARK: - HTTP통신
let DOMAIN                  = "http://52.78.250.89:8080"
let STORE_URL               = "itms-apps://itunes.apple.com/app/id6450642025"

// MARK: - UI 관련
let LIGHT_COLOR = Color.white
let MAIN_COLOR = Color(#colorLiteral(red: 0.2858546078, green: 0.8107966781, blue: 0.6800452471, alpha: 1))

// MARK: - Shortcut
/// UserDefaults.standard
let UDF = UserDefaults.standard

// MARK: - Device 관련
let DEVICE                  = UIDevice.current
let APP_VER                 = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0.0.0"
let DEVICE_TYPE             = "IOS"
let DEVICE_MODEL            = "\(DEVICE.model)\(DEVICE.name)"
let DEVICE_ID               = UIDevice.current.identifierForVendor?.uuidString
let APP_ID                  = Bundle.main.bundleIdentifier ?? "com.isac.myreview"
let DEVICE_VERSION          = "\(DEVICE.systemVersion)"
let APP_NAME                = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? ""

// MARK: - ADMOB 관련
let BANNER_ADMOBKEY             = "ca-app-pub-6912457818283583/1846598436"
let FULL_SCREEN_ADMOBKEY        = "ca-app-pub-6912457818283583/6648367544"

let TEST_BANNER_ADMOBKEY        = "ca-app-pub-3940256099942544/2934735716"
let TEST_FULL_ADMOBKEY          = "ca-app-pub-3940256099942544/4411468910"

// MARK: - FCM관련
let SERVER_KEY              = "key=AAAAdKKV6Fw:APA91bHLLUlljBLPhvqSmQcVEk4DKiJp_CGomE7I2_fEbl3eq5Yz7Sg4NhN3LprJI2jm5jiAVEKBe_L-nF-ogA_JoaHr-W3DfGc8dm6jimYns3GRXIAx4bIWuGPa_8Z-mlau2KZbdFWs"
let FCM_URL                 = "https://fcm.googleapis.com/fcm/send" 
