//
//  CalculateViewController.swift
//  SC
//
//  Created by Narumi Nogawa on 2020/04/27.
//  Copyright © 2020 Narumi Nogawa. All rights reserved.
//

import UIKit

import GoogleMobileAds

class CalculateViewController: UIViewController, GADBannerViewDelegate {
    
    @IBOutlet private weak var topAdView: GADBannerView!
    @IBOutlet private weak var bottomAdView: GADBannerView!
    
    @IBOutlet private weak var memoryLabel: UILabel!
    @IBOutlet private weak var resultLabel: UILabel!
    
    private let greenButtonColor = UIColor(red: 0.8, green: 1.0, blue: 0.8, alpha: 1.0)
    private let TOP_AD_UNIT_ID = "ca-app-pub-6492692627915720/3353518937"
    private let BOTTOM_AD_UNIT_ID = "ca-app-pub-6492692627915720/2126205352"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setAdvertisement()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadBannerAd()
    }
    
    override func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.loadBannerAd()
        })
    }
    
    private func loadBannerAd() {
        let frame = { () -> CGRect in
            return view.frame.inset(by: view.safeAreaInsets)
        }()
        let viewWidth = frame.size.width
        self.topAdView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
        self.topAdView.load(GADRequest())
        self.bottomAdView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
        self.bottomAdView.load(GADRequest())
    }
    
    private func setAdvertisement() {
        self.topAdView.adUnitID = self.TOP_AD_UNIT_ID
        self.topAdView.rootViewController = self
        self.bottomAdView.adUnitID = self.BOTTOM_AD_UNIT_ID
        self.bottomAdView.rootViewController = self
    }
    
}
