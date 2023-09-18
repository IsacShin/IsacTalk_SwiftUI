//
//  BlackBTNStyle.swift
//  IsacTalk
//
//  Created by 신이삭 on 2023/09/18.
//

import Foundation
import SwiftUI

struct ThemeBtnStyle: ButtonStyle {
    var color: Color = .black
    var fontColor: Color = .white
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .font(.system(size: 16))
            .foregroundColor(fontColor)
            .background(color)
            .cornerRadius(16)
            .padding(20)
    }
}

struct ThemeBtnStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button {
            print("clicked")
        } label: {
            Text("호호")
        }.buttonStyle(ThemeBtnStyle())
    }
}

