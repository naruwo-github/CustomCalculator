//
//  CalculateViewController.swift
//  SC
//
//  Created by Narumi Nogawa on 2020/04/27.
//  Copyright © 2020 Narumi Nogawa. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds

class CalculateViewController: UIViewController, GADBannerViewDelegate {
    @IBOutlet weak var topAdView: UIView!
    @IBOutlet weak var bottomAdView: UIView!
    @IBOutlet weak var calculatorView: UIView!
    
    @IBOutlet weak var memoryLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var buttonsView: UIView!
    
    let greenButtonColor = UIColor(red: 0.8, green: 1.0, blue: 0.8, alpha: 1.0)
    
    var topBannerView: GADBannerView!
    var bottomBannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topBannerView = GADBannerView(adSize: kGADAdSizeBanner)
        addTopBannerViewToView(topBannerView)
        topBannerView.adUnitID = "ca-app-pub-6492692627915720/3353518937"
        //Test
        //topBannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        topBannerView.rootViewController = self
        topBannerView.load(GADRequest())
        topBannerView.delegate = self
        
        bottomBannerView = GADBannerView(adSize: kGADAdSizeBanner)
        addBottomBannerViewToView(bottomBannerView)
        bottomBannerView.adUnitID = "ca-app-pub-6492692627915720/2126205352"
        //Test
        //bottomBannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bottomBannerView.rootViewController = self
        bottomBannerView.load(GADRequest())
        bottomBannerView.delegate = self
        
        setNumberButtons()
    }
    
    func setNumberButtons() {
        let frameWidth = self.buttonsView.frame.width
        let frameHeight = self.buttonsView.frame.height
        let buttonWidth = frameWidth / 4 - 5
        let zeroButton = UIButton(type: UIButton.ButtonType.system)
        zeroButton.tag = 0
        zeroButton.setTitle(String(zeroButton.tag), for: UIControl.State.normal)
        zeroButton.titleLabel?.adjustsFontSizeToFitWidth = true
        zeroButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        zeroButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        zeroButton.backgroundColor = greenButtonColor
        zeroButton.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonWidth)
        zeroButton.layer.cornerRadius = zeroButton.frame.height / 2
        zeroButton.center = CGPoint(x: frameWidth/8*3, y: frameHeight/10*9)
        self.buttonsView.addSubview(zeroButton)
    }
    
    func addTopBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        if #available(iOS 11.0, *) {
            positionBannerViewFullWidthAtTopOfSafeArea(bannerView)
        }
        else {
            positionBannerViewFullWidthAtTopOfView(bannerView)
        }
    }
    
    func addBottomBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        if #available(iOS 11.0, *) {
            positionBannerViewFullWidthAtBottomOfSafeArea(bannerView)
        }
        else {
            positionBannerViewFullWidthAtBottomOfView(bannerView)
        }
    }
    
    // MARK: - view positioning
    @available (iOS 11, *)
    func positionBannerViewFullWidthAtTopOfSafeArea(_ bannerView: UIView) {
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            guide.leftAnchor.constraint(equalTo: bannerView.leftAnchor),
            guide.rightAnchor.constraint(equalTo: bannerView.rightAnchor),
            guide.topAnchor.constraint(equalTo: bannerView.topAnchor)
            ])
    }
    
    @available (iOS 11, *)
    func positionBannerViewFullWidthAtBottomOfSafeArea(_ bannerView: UIView) {
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            guide.leftAnchor.constraint(equalTo: bannerView.leftAnchor),
            guide.rightAnchor.constraint(equalTo: bannerView.rightAnchor),
            guide.bottomAnchor.constraint(equalTo: bannerView.bottomAnchor)
            ])
    }
    
    func positionBannerViewFullWidthAtTopOfView(_ bannerView: UIView) {
        view.addConstraint(NSLayoutConstraint(item: bannerView,
                                              attribute: .leading,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .leading,
                                              multiplier: 1,
                                              constant: 0))
        view.addConstraint(NSLayoutConstraint(item: bannerView,
                                              attribute: .trailing,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .trailing,
                                              multiplier: 1,
                                              constant: 0))
        view.addConstraint(NSLayoutConstraint(item: bannerView,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: topLayoutGuide,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: 0))
    }
    
    func positionBannerViewFullWidthAtBottomOfView(_ bannerView: UIView) {
        view.addConstraint(NSLayoutConstraint(item: bannerView,
                                              attribute: .leading,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .leading,
                                              multiplier: 1,
                                              constant: 0))
        view.addConstraint(NSLayoutConstraint(item: bannerView,
                                              attribute: .trailing,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .trailing,
                                              multiplier: 1,
                                              constant: 0))
        view.addConstraint(NSLayoutConstraint(item: bannerView,
                                              attribute: .bottom,
                                              relatedBy: .equal,
                                              toItem: bottomLayoutGuide,
                                              attribute: .top,
                                              multiplier: 1,
                                              constant: 0))
    }
}
