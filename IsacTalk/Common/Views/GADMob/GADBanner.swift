//
//  GADBanner.swift
//  IsacTalk
//
//  Created by 신이삭 on 2023/09/26.
//

import Foundation
import UIKit
import GoogleMobileAds
import SwiftUI

struct GADBanner: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let bannerWidth = UIScreen.main.bounds.width
        let bannerSize = GADPortraitAnchoredAdaptiveBannerAdSizeWithWidth(bannerWidth)
        let adSize = GADAdSizeFromCGSize(CGSize(width: bannerWidth, height: bannerSize.size.height))

        let view = GADBannerView(adSize: adSize)
        let viewController = UIViewController()
        #if DEBUG
        view.adUnitID = TEST_BANNER_ADMOBKEY // test Key
        #endif
        #if RELEASE
        view.adUnitID = BANNER_ADMOBKEY
        #endif
        view.rootViewController = viewController
        viewController.view.addSubview(view)
        viewController.view.frame = CGRect(origin: .zero, size: GADAdSizeBanner.size)
        view.load(GADRequest())
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    
    }
}
