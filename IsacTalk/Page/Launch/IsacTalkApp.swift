//
//  IsacTalkApp.swift
//  IsacTalk
//
//  Created by 신이삭 on 2023/09/18.
//

import SwiftUI
import UserNotifications
import Firebase
import GoogleMobileAds

enum RootViewType {
    case Splash
    case CommonTabView
}

final class AppVM: ObservableObject {
    @Published var rootViewId: RootViewType = .Splash
}

@main
struct IsacTalkApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
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

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        FirebaseManager.shared.messaging.delegate = self
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        //파이어베이스 푸시 등록
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {didAllow, Error in
            
        })
        
        application.registerForRemoteNotifications()
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.map { String(format: "%02x", $0) }.joined()
        print("디바이스 토큰값 : "+deviceTokenString)
    }
}

extension AppDelegate:UNUserNotificationCenterDelegate, MessagingDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge,.sound])
    }
}
