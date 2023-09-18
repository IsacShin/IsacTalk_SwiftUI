//
//  AccessGuideV.swift
//  IsacTalk
//
//  Created by 신이삭 on 2023/09/18.
//

import SwiftUI
import CoreLocation
import Photos

struct AccessGuideV: View {
    
    @EnvironmentObject var appVM: AppVM
    @ObservedObject var vm = AccessGuideVM()
    @Binding var isGuideShow: Bool
    
    var body: some View {
        ZStack {
            
            MAIN_COLOR
                .edgesIgnoringSafeArea(.all)
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    Text("앱 사용을 위해\n접근 권한을 허용해주세요")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .lineSpacing(6.0)
                        .minimumScaleFactor(0.01)
                        .lineLimit(nil)
                        .multilineTextAlignment(.leading)

                    Spacer().frame(height: 20)
                    Text("선택 권한의 경우 허용하지 않아도\n서비스를 사용할 수 있으나 일부 서비스 이용이 제한됩니다.")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.white)
                        .lineSpacing(3.0)
                        .lineLimit(nil)

                    
                    Spacer().frame(height: 41)
                    AccessElementV(image: "camera.fill", title: "카메라", subTitle: "카메라 이용 권한")
                    Spacer().frame(height: 20)
                    AccessElementV(image: "circle.inset.filled", title: "광고 허용", subTitle: "광고 접근 허용")
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .onAppear {
                for family: String in UIFont.familyNames {
                    print(family)
                    for names : String in UIFont.fontNames(forFamilyName: family){
                        print("=== \(names)")
                    }
                }
            }
            
            VStack {
                Spacer()
                Button {
                    DispatchQueue.main.async {
                        self.vm.showCameraPermission()
                    }
                } label: {
                    Text("완료")
                }
                .buttonStyle(ThemeBtnStyle(color: .init(white: 0, opacity: 0.75)))

            }
        }
        .onReceive(self.vm.success) { result in
            if result {
                DispatchQueue.main.async {
                    self.isGuideShow = false
                    UDF.set(true, forKey: "firstLaunch")
                    NaviManager.popToRootView {
                        withAnimation {
                            appVM.rootViewId = .CommonTabView
                        }
                    }
                }
                
            }
        }
    }
}

struct AccessElementV: View {
    var image: String
    var title: String
    var subTitle: String
    
    var body: some View {
        HStack {
            Image(systemName: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24)
                .foregroundColor(.white)
                
            Spacer().frame(width: 10)
            Text(title)
                .font(.system(size: 16))
                .foregroundColor(.white)
            Spacer().frame(width: 16)
            Text(subTitle)
                .font(.system(size: 16))
                .foregroundColor(.white)
        }
    }
}



struct AccessGuideV_Previews: PreviewProvider {
    static var previews: some View {
        AccessGuideV(isGuideShow: .constant(true))
    }
}
