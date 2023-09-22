//
//  CommonLoadingV.swift
//  IsacTalk
//
//  Created by 신이삭 on 2023/09/21.
//

import SwiftUI

struct CommonLoadingV: View {
    var body: some View {
        ZStack(alignment: .center) {
            Color.black.opacity(0.8)
                .edgesIgnoringSafeArea(.all)
            
            CommonLoadingIndicator()
        }
    }
}

struct CommonLoadingWrapV_Previews: PreviewProvider {
    static var previews: some View {
        CommonLoadingV()
    }
}
