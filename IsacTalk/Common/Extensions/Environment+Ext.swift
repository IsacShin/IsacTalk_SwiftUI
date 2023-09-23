//
//  Environment+Ext.swift
//  IsacTalk
//
//  Created by 신이삭 on 2023/09/23.
//

import Foundation
import SwiftUI

@available(iOS 14.0, *)
extension EnvironmentValues {
    var dismiss: () -> Void {
        { presentationMode.wrappedValue.dismiss() }
    }
}
