//
//  SplashV.swift
//  IsacTalk
//
//  Created by 신이삭 on 2023/09/18.
//

import SwiftUI
import AppTrackingTransparency
import AdSupport

struct SplashV: View {
    var idfa: UUID {
        return ASIdentifierManager.shared().advertisingIdentifier
    }
    
    @ObservedObject var vm: SplashVM = SplashVM()
    @EnvironmentObject var appVM: AppVM
    @State var isAnim = false
    @State var isAnim2 = false
    @State var isGuideShow = false
    
    var body: some View {
        ZStack {
            MAIN_COLOR
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                Group {
                    Image("LOGO")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: SCREEN_WIDTH - 40, height: 150)
                        .offset(y: 38)
                        .opacity(isAnim2 ? 1.0 : 0.0)
                    Text("IsacTalk")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                        .opacity(isAnim2 ? 1.0 : 0.0)
                    Spacer().frame(height: 10)
                    Text("간편하게 즐기는 1대1 채팅")
                        .foregroundColor(.white)
                        .font(.system(size: 17))
                        .opacity(isAnim ? 1.0 : 0.0)
                }
                .offset(y: -100)
                
                Spacer()
                Text("CopyrightⒸ 2023. ISAC. All Right Reserved.")
                    .foregroundColor(.white)
                    .font(.system(size: 13))
            }
        }
        .onAppear {
            withAnimation(.easeIn(duration: 1.0)) {
                self.isAnim = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                    withAnimation(.easeIn(duration: 0.5)) {
                        self.isAnim2 = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            self.vm.startLaunch()
                        }
                    }
                })
                
            }
        }
        .onReceive(self.vm.nextAction) { state in
            switch state {
                case .first:
                    self.isGuideShow = true
                case .yet:
                    NaviManager.popToRootView {
                        withAnimation {
                            appVM.rootViewId = .CommonTabView
                        }
                    }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            UIApplication.shared.applicationIconBadgeNumber = 0

            ATTrackingManager.requestTrackingAuthorization { [self] status in
                switch status {
                case .authorized:
                    print("광고추적 허용")
                    print("IDFA: ", self.idfa)
                case .denied, .notDetermined, .restricted:
                    print("광고추적 비허용")
                    print("IDFA: ", self.idfa)
                @unknown default:
                    print("UNKNOWN")
                    print("IDFA: ", self.idfa)
                }
            }
                }
        .fullScreenCover(isPresented: $isGuideShow) {
            AccessGuideV(isGuideShow: $isGuideShow)
        }
        
    }
}

struct SplashV_Previews: PreviewProvider {
    static var previews: some View {
        SplashV()
    }
}
