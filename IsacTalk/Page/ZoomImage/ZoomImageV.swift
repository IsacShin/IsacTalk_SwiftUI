//
//  ZoomImageV.swift
//  IsacTalk
//
//  Created by 신이삭 on 2023/09/26.
//

import SwiftUI
import SDWebImageSwiftUI
import UIKit

struct ZoomImageV: View {
    let chatImg: String

    @State private var currentScale: CGFloat = 1.0
    private let minScale: CGFloat = 1.0
    private let maxScale: CGFloat = 4.0

    @Environment(\.dismiss) var dismiss
    
    init(chatImg: String) {
        self.chatImg = chatImg
        
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            VStack {
                CustomNavigationBar
                Spacer()
            }
                
            WebImage(url: URL(string: chatImg))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaleEffect(currentScale)
                .gesture(
                    MagnificationGesture()
                        .onChanged { value in
                            currentScale = min(max(currentScale * value, minScale), maxScale)
                        }
                )
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .navigationBarHidden(true)
    }
    
    private var CustomNavigationBar: some View {
        HStack {
            
            Button(action: {
                dismiss()
            }) {
                Image("close")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
            }
            Spacer()
        }
        .padding()
        .background(Color.black)
    }
}


struct ZoomImageV_Previews: PreviewProvider {
    static var previews: some View {
        ZoomImageV(chatImg: "https://mblogthumb-phinf.pstatic.net/MjAxODA0MjhfMjQ3/MDAxNTI0ODgxODM2ODg4.qQGPRwKWHTgq1R2XIx2f5hNExkrL60L4xuB08IW5gC0g.Zbu_z7BSjkCeoCeylaV4QmMyHiBAIZSIN87H8ob3eLIg.JPEG.ichufs/IMG_8931s.jpg?type=w800")
    }
}
