//
//  ViewController.swift
//  SC
//
//  Created by Narumi Nogawa on 2019/09/08.
//  Copyright © 2019 Narumi Nogawa. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController, GADBannerViewDelegate {
    //Advertisement View
    var topBannerView: GADBannerView!
    var bottomBannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //========================================================================
        //=====Advertisement=====
        // In this case, we instantiate the banner with desired ad size.
        //top
        topBannerView = GADBannerView(adSize: kGADAdSizeBanner)
        addTopBannerViewToView(topBannerView)
        //topBannerView.adUnitID = "ca-app-pub-6492692627915720/3353518937"
        //Test
        topBannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        topBannerView.rootViewController = self
        topBannerView.load(GADRequest())
        topBannerView.delegate = self
        
        //bottom
        bottomBannerView = GADBannerView(adSize: kGADAdSizeBanner)
        addBottomBannerViewToView(bottomBannerView)
        //bottomBannerView.adUnitID = "ca-app-pub-6492692627915720/2126205352"
        //Test
        bottomBannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bottomBannerView.rootViewController = self
        bottomBannerView.load(GADRequest())
        bottomBannerView.delegate = self
        //========================================================================
        
        let width = self.view.frame.width
        let height = self.view.frame.height
        setLabels(wid: width, hei: height)
        setNumberButtons(wid: width, hei: height)
        setOperationButtons(wid: width, hei: height)
        print(width)
        print(height)
    }
    
    //memory and result label
    func setLabels(wid: CGFloat, hei: CGFloat) {
        //2labels are implemented
    }
    
    //number button
    func setNumberButtons(wid: CGFloat, hei: CGFloat) {
        //side length of buttons
        let w = wid/4
        let bottom = hei-150
        //making buttons No.0~9
        for i in 0..<10 {
            let numButton = UIButton()
            numButton.tag = i+1
            numButton.setTitle(String(i), for: UIControl.State.normal)
            numButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
            numButton.backgroundColor = UIColor.init(red: 0.8, green: 1, blue: 0.8, alpha: 1)
            numButton.frame = CGRect(x: 0, y: 0, width: w, height: w)
            self.view.addSubview(numButton)
        }
        if let button0 = self.view.viewWithTag(1) {
            button0.center = CGPoint(x: w/2*3, y: bottom)
        }
        if let button1 = self.view.viewWithTag(2) {
            button1.center = CGPoint(x: w/2, y: bottom-w)
        }
        if let button2 = self.view.viewWithTag(3) {
            button2.center = CGPoint(x: w/2*3, y: bottom-w)
        }
        if let button3 = self.view.viewWithTag(4) {
            button3.center = CGPoint(x: w/2*5, y: bottom-w)
        }
        if let button4 = self.view.viewWithTag(5) {
            button4.center = CGPoint(x: w/2, y: bottom-w*2)
        }
        if let button5 = self.view.viewWithTag(6) {
            button5.center = CGPoint(x: w/2*3, y: bottom-w*2)
        }
        if let button6 = self.view.viewWithTag(7) {
            button6.center = CGPoint(x: w/2*5, y: bottom-w*2)
        }
        if let button7 = self.view.viewWithTag(8) {
            button7.center = CGPoint(x: w/2, y: bottom-w*3)
        }
        if let button8 = self.view.viewWithTag(9) {
            button8.center = CGPoint(x: w/2*3, y: bottom-w*3)
        }
        if let button9 = self.view.viewWithTag(10) {
            button9.center = CGPoint(x: w/2*5, y: bottom-w*3)
        }
    }
    
    //operation button
    func setOperationButtons(wid: CGFloat, hei: CGFloat) {
        //side length of buttons
        let w = wid/4
        let bottom = hei-150
        
        //making operation buttons
        //Pop last charactor
        let buttonC = UIButton()
        buttonC.tag = 11
        buttonC.setTitle("C", for: UIControl.State.normal)
        buttonC.setTitleColor(UIColor.black, for: UIControl.State.normal)
        buttonC.backgroundColor = UIColor.init(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        buttonC.frame = CGRect(x: 0, y: 0, width: w, height: w)
        buttonC.center = CGPoint(x: w/2, y: bottom)
        self.view.addSubview(buttonC)
        //Point button ...
        let buttonP = UIButton()
        buttonP.tag = 12
        buttonP.setTitle(".", for: UIControl.State.normal)
        buttonP.setTitleColor(UIColor.black, for: UIControl.State.normal)
        buttonP.backgroundColor = UIColor.init(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        buttonP.frame = CGRect(x: 0, y: 0, width: w, height: w)
        buttonP.center = CGPoint(x: w/2*5, y: bottom)
        self.view.addSubview(buttonP)
        //Equal button
        let buttonE = UIButton()
        buttonE.tag = 13
        buttonE.setTitle("C", for: UIControl.State.normal)
        buttonE.setTitleColor(UIColor.black, for: UIControl.State.normal)
        buttonE.backgroundColor = UIColor.init(red: 1, green: 1, blue: 0.8, alpha: 1)
        buttonE.frame = CGRect(x: 0, y: 0, width: w, height: w)
        buttonE.center = CGPoint(x: w/2*7, y: bottom)
        self.view.addSubview(buttonE)
        //Add button
        let buttonA = UIButton()
        buttonA.tag = 14
        buttonA.setTitle("+", for: UIControl.State.normal)
        buttonA.setTitleColor(UIColor.black, for: UIControl.State.normal)
        buttonA.backgroundColor = UIColor.init(red: 1, green: 1, blue: 0.8, alpha: 1)
        buttonA.frame = CGRect(x: 0, y: 0, width: w, height: w)
        buttonA.center = CGPoint(x: w/2*7, y: bottom-w)
        self.view.addSubview(buttonA)
        //Sub button
        let buttonS = UIButton()
        buttonS.tag = 15
        buttonS.setTitle("-", for: UIControl.State.normal)
        buttonS.setTitleColor(UIColor.black, for: UIControl.State.normal)
        buttonS.backgroundColor = UIColor.init(red: 1, green: 1, blue: 0.8, alpha: 1)
        buttonS.frame = CGRect(x: 0, y: 0, width: w, height: w)
        buttonS.center = CGPoint(x: w/2*7, y: bottom-w*2)
        self.view.addSubview(buttonS)
        //Multiply
        let buttonM = UIButton()
        buttonM.tag = 16
        buttonM.setTitle("×", for: UIControl.State.normal)
        buttonM.setTitleColor(UIColor.black, for: UIControl.State.normal)
        buttonM.backgroundColor = UIColor.init(red: 1, green: 1, blue: 0.8, alpha: 1)
        buttonM.frame = CGRect(x: 0, y: 0, width: w, height: w)
        buttonM.center = CGPoint(x: w/2*7, y: bottom-w*3)
        self.view.addSubview(buttonM)
        //Division
        let buttonD = UIButton()
        buttonD.tag = 17
        buttonD.setTitle("×", for: UIControl.State.normal)
        buttonD.setTitleColor(UIColor.black, for: UIControl.State.normal)
        buttonD.backgroundColor = UIColor.init(red: 1, green: 1, blue: 0.8, alpha: 1)
        buttonD.frame = CGRect(x: 0, y: 0, width: w, height: w)
        buttonD.center = CGPoint(x: w/2*7, y: bottom-w*4)
        self.view.addSubview(buttonD)
        //All Clear button
        let buttonAC = UIButton()
        buttonAC.tag = 18
        buttonAC.setTitle("AC", for: UIControl.State.normal)
        buttonAC.setTitleColor(UIColor.black, for: UIControl.State.normal)
        buttonAC.backgroundColor = UIColor.init(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        buttonAC.frame = CGRect(x: 0, y: 0, width: w, height: w)
        buttonAC.center = CGPoint(x: w/2, y: bottom-w*4)
        self.view.addSubview(buttonAC)
        //Plus Minus button
        let buttonPM = UIButton()
        buttonPM.tag = 19
        buttonPM.setTitle("±", for: UIControl.State.normal)
        buttonPM.setTitleColor(UIColor.black, for: UIControl.State.normal)
        buttonPM.backgroundColor = UIColor.init(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        buttonPM.frame = CGRect(x: 0, y: 0, width: w, height: w)
        buttonPM.center = CGPoint(x: w/2*3, y: bottom-w*4)
        self.view.addSubview(buttonPM)
        //Surplus button
        let buttonSU = UIButton()
        buttonSU.tag = 20
        buttonSU.setTitle("%", for: UIControl.State.normal)
        buttonSU.setTitleColor(UIColor.black, for: UIControl.State.normal)
        buttonSU.backgroundColor = UIColor.init(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        buttonSU.frame = CGRect(x: 0, y: 0, width: w, height: w)
        buttonSU.center = CGPoint(x: w/2*5, y: bottom-w*4)
        self.view.addSubview(buttonSU)
    }
    
    func addTopBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        if #available(iOS 11.0, *) {
            // In iOS 11, we need to constrain the view to the safe area.
            positionBannerViewFullWidthAtTopOfSafeArea(bannerView)
        }
        else {
            // In lower iOS versions, safe area is not available so we use
            // bottom layout guide and view edges.
            positionBannerViewFullWidthAtTopOfView(bannerView)
        }
    }
    
    func addBottomBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        if #available(iOS 11.0, *) {
            // In iOS 11, we need to constrain the view to the safe area.
            positionBannerViewFullWidthAtBottomOfSafeArea(bannerView)
        }
        else {
            // In lower iOS versions, safe area is not available so we use
            // bottom layout guide and view edges.
            positionBannerViewFullWidthAtBottomOfView(bannerView)
        }
    }
    
    // MARK: - view positioning
    @available (iOS 11, *)
    func positionBannerViewFullWidthAtTopOfSafeArea(_ bannerView: UIView) {
        // Position the banner. Stick it to the bottom of the Safe Area.
        // Make it constrained to the edges of the safe area.
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            guide.leftAnchor.constraint(equalTo: bannerView.leftAnchor),
            guide.rightAnchor.constraint(equalTo: bannerView.rightAnchor),
            guide.topAnchor.constraint(equalTo: bannerView.topAnchor)
            ])
    }
    
    @available (iOS 11, *)
    func positionBannerViewFullWidthAtBottomOfSafeArea(_ bannerView: UIView) {
        // Position the banner. Stick it to the bottom of the Safe Area.
        // Make it constrained to the edges of the safe area.
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
    
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        //print("adViewDidReceiveAd")
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        //print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        //print("adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        //print("adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        //print("adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        //print("adViewWillLeaveApplication")
    }
}

