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
    
    @IBOutlet private weak var topAdView: UIView!
    @IBOutlet private weak var bottomAdView: UIView!
    @IBOutlet private weak var calculatorView: UIView!
    
    @IBOutlet private weak var memoryLabel: UILabel!
    @IBOutlet private weak var resultLabel: UILabel!
    @IBOutlet private weak var buttonsView: UIView!
    
    private let greenButtonColor = UIColor(red: 0.8, green: 1.0, blue: 0.8, alpha: 1.0)
    private let TOP_AD_UNIT_ID = "ca-app-pub-6492692627915720/3353518937"
    private let BOTTOM_AD_UNIT_ID = "ca-app-pub-6492692627915720/2126205352"
    private var topBannerView: GADBannerView!
    private var bottomBannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setAdvertisement()
    }
    
    private func setAdvertisement() {
        self.topBannerView = GADBannerView(adSize: kGADAdSizeBanner)
        self.topBannerView.adUnitID = self.TOP_AD_UNIT_ID
        self.topBannerView.rootViewController = self
        self.topBannerView.load(GADRequest())
        self.topBannerView.delegate = self
        self.topBannerView.center.x = self.view.center.x
        self.topAdView.addSubview(self.topBannerView)
        
        self.bottomBannerView = GADBannerView(adSize: kGADAdSizeBanner)
        self.bottomBannerView.adUnitID = self.BOTTOM_AD_UNIT_ID
        self.bottomBannerView.rootViewController = self
        self.bottomBannerView.load(GADRequest())
        self.bottomBannerView.delegate = self
        self.bottomBannerView.center.x = self.view.center.x
        self.bottomAdView.addSubview(self.bottomBannerView)
    }
    
}
