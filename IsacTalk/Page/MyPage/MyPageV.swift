//
//  MyPageV.swift
//  IsacTalk
//
//  Created by 신이삭 on 2023/09/26.
//

import SwiftUI
import SDWebImageSwiftUI
import GoogleMobileAds

struct MyPageV: View {
    @EnvironmentObject var appVM: AppVM

    @State var showAlert: Bool = false
    @State var alertType: AlertType = .loginOutConfirm
    @Binding var selectTab: TabType

    var body: some View {
        ZStack {
            MAIN_COLOR
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 0) {
                Spacer().frame(height: 40)
                WebImage(url: URL(string: AppManager.loginUser?.profileImageUrl ?? ""))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 150)
                    .clipped()
                    .cornerRadius(150)
                    .overlay(Circle().stroke(style: StrokeStyle(lineWidth: 2)).foregroundColor(.white))
                    .shadow(radius: 5)
                
                Spacer().frame(height: 20)
                Text(AppManager.loginUser?.name ?? "신이삭")
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer().frame(height: 10)
                Text(AppManager.loginUser?.email ?? "isac9305@naver.com")
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer().frame(height: 20)
                HStack {
                    Text("v\(APP_VER)")
                        .foregroundColor(.white)
                    
                    Divider().frame(width: 2, height: 15)
                        .background(Color.white)
                    
                    Button {
                        self.alertType = .loginOutConfirm
                        self.showAlert.toggle()
                    } label: {
                        Text("로그아웃")
                            .foregroundColor(.white)
                    }

                }
                
                Group {
                    Spacer()
                    Button {
                        self.alertType = .removeMemberConfirm
                        self.showAlert.toggle()
                    } label: {
                        Text("회원탈퇴")
                            .foregroundColor(.red)
                    }
                    Spacer().frame(height: 20)
                }
                
                AdmobV()
                
            }

        }
        .alert(isPresented: $showAlert) {
            if alertType == .loginOutConfirm {
                return Alert(title: Text(alertType.rawValue), primaryButton: .default(Text("확인"), action: {
                    AppManager.logout {
                        self.selectTab = .HOME
                        DispatchQueue.main.async {
                            NaviManager.popToRootView {
                                appVM.rootViewId = .CommonTabView
                            }
                        }
                    }
                }), secondaryButton: .cancel(Text("취소")))
            } else {
                return Alert(title: Text(alertType.rawValue), primaryButton: .default(Text("확인"), action: {
                    AppManager.removeId {
                        AppManager.logout {
                            self.selectTab = .HOME
                            DispatchQueue.main.async {
                                NaviManager.popToRootView {
                                    appVM.rootViewId = .CommonTabView
                                }
                            }
                        }
                    }
                }), secondaryButton: .cancel(Text("취소")))
            }
            
        }

    }
}

@ViewBuilder func AdmobV() -> some View {
    // admob
    let bannerWidth = UIScreen.main.bounds.width
    let bannerSize = GADPortraitAnchoredAdaptiveBannerAdSizeWithWidth(bannerWidth)
    GADBanner().frame(width: bannerWidth, height: bannerSize.size.height)

}


struct MyPageV_Previews: PreviewProvider {
    static var previews: some View {
        MyPageV(selectTab: .constant(.MYPAGE))
    }
}
