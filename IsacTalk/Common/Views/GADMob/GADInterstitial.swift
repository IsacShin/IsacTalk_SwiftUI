//
//  GADInterstitial.swift
//  IsacTalk
//
//  Created by 신이삭 on 2023/09/26.
//

import SwiftUI
import GoogleMobileAds
import UIKit
    
#if DEBUG
let adUnitID = TEST_FULL_ADMOBKEY
#else
let adUnitID = FULL_SCREEN_ADMOBKEY
#endif

final class GADInterstitial: NSObject, GADFullScreenContentDelegate {
    
    static let shared = GADInterstitial()
    private var interstitial: GADInterstitialAd?
    
    func loadFullAd() {
        DispatchQueue.main.async {
            GADInterstitialAd.load(withAdUnitID: adUnitID, request: GADRequest()) { ad, error in
                if error != nil { return }
                if let ad = ad {
                    self.interstitial = ad
                    self.interstitial?.fullScreenContentDelegate = self
                    
                    if self.interstitial != nil {
                        guard let root = WINDOW?.rootViewController else { return }
                        self.interstitial?.present(fromRootViewController: root)
                    } else {
                        print("Ad wasn't ready")
                    }
                }
            }
        }
    }
}
