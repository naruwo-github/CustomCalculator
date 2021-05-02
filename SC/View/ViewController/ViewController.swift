//
//  ViewController.swift
//  SC
//
//  Created by Narumi Nogawa on 2019/09/08.
//  Copyright © 2019 Narumi Nogawa. All rights reserved.
//

import AppTrackingTransparency
import AdSupport
import UIKit
import GoogleMobileAds

class ViewController: UIViewController {
    
    @IBOutlet private weak var topAdvertisementView: UIView!
    @IBOutlet private weak var bottomAdvertisementView: UIView!
    
    private var topBannerView: GADBannerView!
    private var bottomBannerView: GADBannerView!
    private let resultLabel: UILabel = UILabel()
    private var numOnScreen: Float = 0
    private var preNum: Float = 0
    private var canCalculate: Bool = false
    private var operationNum: Int = 0
    private var moveToRight: CGFloat = 0
    private let memoryLabel: UILabel = UILabel()
    private var memoryNumOnScreen: Float = 0
    private let memoryMark = UILabel()
    private let url = NSURL(string: PSCStringStorage.init().BLOG_URL)
    
    private let buttonColorGreen = UIColor(red: 0.8, green: 1, blue: 0.8, alpha: 1)
    private let buttonColorCream = UIColor(red: 1, green: 1, blue: 0.8, alpha: 1)
    private let buttonColorLightGray = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
    private let buttonColorDarkGray = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var width = self.view.frame.width
        var height = self.view.frame.height
        if UIDevice.current.userInterfaceIdiom == .pad {
            width -= 200
            height -= 20
            self.moveToRight = width/8
        } else {
            if UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20 {
                height -= 34
            }
        }
        self.setLabels(wid: width, hei: height)
        self.setNumberButtons(wid: width, hei: height)
        
        self.setupOperationButtonsFormarHalf(wid: width, hei: height)
        self.setupOperationButtonsLatterHalf(wid: width, hei: height)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setAdvertisement()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.requestIDFA()
    }
    
    @objc private func numberButtonEvent(_ sender: UIButton) {
        if self.canCalculate == true || self.resultLabel.text == "0" {
            self.resultLabel.text = String(sender.tag-1)
            self.numOnScreen = NSString(string: self.resultLabel.text!).floatValue
            self.canCalculate = false
        } else {
            self.resultLabel.text = self.resultLabel.text! + String(sender.tag-1)
            self.numOnScreen = NSString(string: self.resultLabel.text!).floatValue
        }
    }
    
    @objc private func operationButtonEvent(_ sender: UIButton) {
        if sender.tag < 20 {
            self.operationButtonEventLowerTwenty(sender: sender)
        } else {
            self.operationButtonEventUpperTwenty(sender: sender)
        }
    }
    
    private func requestIDFA() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { _ in })
        }
    }
    
    private func operationButtonEventLowerTwenty(sender: UIButton) {
        if sender.tag == 11 { // C
            if self.resultLabel.text!.count > 1 {
                _ = self.resultLabel.text!.popLast()
                self.numOnScreen = NSString(string: self.resultLabel.text!).floatValue
            } else {
                self.resultLabel.text = "0"
                self.numOnScreen = 0
            }
        } else if sender.tag == 12 { // Point
            if self.getLastChar() != "." {
                self.resultLabel.text?.append(".")
            } else {
                _ = self.resultLabel.text?.popLast()
            }
        } else if sender.tag == 13 { // =
            self.calculateOperation()
        } else if sender.tag == 14 { // +
            self.calculateOperation() // 最後がoperationじゃないかの確認
            if self.getLastChar() >= "0" && self.getLastChar() <= "9" {
            } else {
                _ = self.resultLabel.text?.popLast()
            }
            self.preNum = NSString(string: self.resultLabel.text!).floatValue
            self.resultLabel.text?.append("+")
            self.operationNum = sender.tag
            self.canCalculate = true
        } else if sender.tag == 15 { // -
            self.calculateOperation() // 最後がoperationじゃないかの確認
            if self.getLastChar() >= "0" && self.getLastChar() <= "9" {
            } else {
                _ = self.resultLabel.text?.popLast()
            }
            self.preNum = NSString(string: self.resultLabel.text!).floatValue
            self.resultLabel.text?.append("-")
            self.operationNum = sender.tag
            self.canCalculate = true
        } else if sender.tag == 16 { // ×
            self.calculateOperation() // 最後がoperationじゃないかの確認
            if self.getLastChar() >= "0" && self.getLastChar() <= "9" {
            } else {
                _ = self.resultLabel.text?.popLast()
            }
            self.preNum = NSString(string: self.resultLabel.text!).floatValue
            self.resultLabel.text?.append("×")
            self.operationNum = sender.tag
            self.canCalculate = true
        } else if sender.tag == 17 { // AC
            self.resultLabel.text = "0"
            self.preNum = 0
            self.numOnScreen = 0
            self.operationNum = 0
        } else if sender.tag == 18 { // +/-
            self.preNum = NSString(string: self.resultLabel.text!).floatValue
            var tmp = NSString(string: self.resultLabel.text!).floatValue
            tmp *= -1.0
            self.numOnScreen = tmp
            self.resultLabel.text = String(tmp)
        } else if sender.tag == 19 { // %
            self.calculateOperation() // 最後がoperationじゃないかの確認
            if self.getLastChar() >= "0" && self.getLastChar() <= "9" {
            } else {
                _ = self.resultLabel.text?.popLast()
            }
            self.preNum = NSString(string: self.resultLabel.text!).floatValue
            self.resultLabel.text?.append("%")
            self.operationNum = sender.tag
            self.canCalculate = true
        }
    }
    
    private func operationButtonEventUpperTwenty(sender: UIButton) {
        if sender.tag == 20 { // ÷
            self.calculateOperation() // 最後がoperationじゃないかの確認
            if self.getLastChar() >= "0" && self.getLastChar() <= "9" {
            } else {
                _ = self.resultLabel.text?.popLast()
            }
            self.preNum = NSString(string: self.resultLabel.text!).floatValue
            self.resultLabel.text?.append("÷")
            self.operationNum = sender.tag
            self.canCalculate = true
        } else if sender.tag == 21 { // √
            // TODO: perationじゃないかの確認 する？
            if self.getLastChar() >= "0" && self.getLastChar() <= "9" {
                self.preNum = NSString(string: self.resultLabel.text!).floatValue
                self.resultLabel.text = String(sqrtf(self.numOnScreen))
                self.numOnScreen = NSString(string: self.resultLabel.text!).floatValue
            } else {
                _ = self.resultLabel.text?.popLast()
            }
        } else if sender.tag == 22 { // !
            // TODO: perationじゃないかの確認 する？
            if self.resultLabel.text == "0" || self.resultLabel.text == "0.0" {
            } else {
                self.preNum = NSString(string: self.resultLabel.text!).floatValue
                let roop = Int(self.numOnScreen)
                var ans = 1
                for i in 0..<roop {
                    ans *= i+1
                }
                self.resultLabel.text = String(ans)
                self.numOnScreen = NSString(string: self.resultLabel.text!).floatValue
            }
        } else if sender.tag == 23 { // 1/x
            // TODO: perationじゃないかの確認 する？
            if self.resultLabel.text == "0" || self.resultLabel.text == "0.0" {
            } else {
                self.preNum = NSString(string: self.resultLabel.text!).floatValue
                self.resultLabel.text = String(1/self.numOnScreen)
                self.numOnScreen = NSString(string: self.resultLabel.text!).floatValue
            }
        } else if sender.tag == 24 { // ^x
            self.calculateOperation() // 最後がoperationじゃないかの確認
            if self.getLastChar() >= "0" && self.getLastChar() <= "9" {
            } else {
                _ = self.resultLabel.text?.popLast()
            }
            self.preNum = NSString(string: self.resultLabel.text!).floatValue
            self.resultLabel.text?.append("^")
            self.operationNum = sender.tag
            self.canCalculate = true
        } else if sender.tag == 25 { // 10^x
            // TODO: perationじゃないかの確認 する？
            if self.resultLabel.text == "0" || self.resultLabel.text == "0.0" {
            } else {
                self.preNum = NSString(string: self.resultLabel.text!).floatValue
                self.resultLabel.text = String(powf(10, self.numOnScreen))
                self.numOnScreen = NSString(string: self.resultLabel.text!).floatValue
            }
        } else if sender.tag == 26 { // mc
            self.memoryNumOnScreen = 0
            self.memoryLabel.text = String(self.memoryNumOnScreen)
        } else if sender.tag == 27 { // m+
            self.memoryNumOnScreen += self.numOnScreen
            self.memoryLabel.text = String(self.memoryNumOnScreen)
        } else if sender.tag == 28 { // m-
            self.memoryNumOnScreen -= self.numOnScreen
            self.memoryLabel.text = String(self.memoryNumOnScreen)
        } else if sender.tag == 29 { // mr
            self.numOnScreen = self.memoryNumOnScreen
            self.resultLabel.text = String(self.numOnScreen)
        } else if sender.tag == 30 { // Hatena Button
            if UIApplication.shared.canOpenURL(self.url! as URL) {
                UIApplication.shared.open(self.url! as URL, options: [:], completionHandler: nil)
            }
        }
    }
    
    private func calculateOperation() {
        if self.operationNum == 14 {
            self.resultLabel.text = String(self.preNum + self.numOnScreen)
            self.numOnScreen += self.preNum
        } else if operationNum == 15 {
            self.resultLabel.text = String(self.preNum - self.numOnScreen)
            self.numOnScreen -= self.preNum
        } else if operationNum == 16 {
            self.resultLabel.text = String(self.preNum * self.numOnScreen)
            self.numOnScreen *= self.preNum
        } else if self.operationNum == 19 {
            self.resultLabel.text = String(self.preNum.truncatingRemainder(dividingBy: self.numOnScreen))
            self.numOnScreen = self.preNum.truncatingRemainder(dividingBy: self.numOnScreen)
        } else if self.operationNum == 20 {
            self.resultLabel.text = String(self.preNum / self.numOnScreen)
            self.numOnScreen /= self.preNum
        } else if operationNum == 24 {
            self.resultLabel.text = String(powf(self.preNum, self.numOnScreen))
            self.numOnScreen = powf(self.preNum, self.numOnScreen)
        }
        self.operationNum = 0
    }
    
    private func setLabels(wid: CGFloat, hei: CGFloat) {
        let w = wid/5
        let bottom = hei-50-w/2
        
        resultLabel.backgroundColor = UIColor.black
        resultLabel.textColor = UIColor.white
        resultLabel.text = "0"
        resultLabel.textAlignment = NSTextAlignment.right
        resultLabel.font = UIFont.systemFont(ofSize: 80)
        resultLabel.adjustsFontSizeToFitWidth = true
        self.view.addSubview(resultLabel)
        
        memoryLabel.backgroundColor = UIColor.black
        memoryLabel.textColor = UIColor.white
        memoryLabel.text = "0"
        memoryLabel.textAlignment = NSTextAlignment.right
        memoryLabel.font = UIFont.systemFont(ofSize: 40)
        memoryLabel.adjustsFontSizeToFitWidth = true
        self.view.addSubview(memoryLabel)
        
        memoryMark.backgroundColor = UIColor.black
        memoryMark.textColor = UIColor.white
        memoryMark.font = UIFont.systemFont(ofSize: 20)
        memoryMark.text = "Memory"
        self.view.addSubview(memoryMark)
        if UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20 {
            // weather iphone is X or not
            resultLabel.frame = CGRect.init(x: 0, y: 0, width: wid, height: w)
            resultLabel.center = CGPoint.init(x: w*5/2+moveToRight, y: bottom-w*6)
            
            memoryLabel.frame = CGRect.init(x: 0, y: 0, width: wid/2, height: w/2-2)
            memoryLabel.center = CGPoint.init(x: w*7/2+moveToRight, y: bottom-w*7+w/4+1)
            
            memoryMark.frame = CGRect.init(x: 0, y: 0, width: wid/4, height: w/2-2)
            memoryMark.center = CGPoint.init(x: wid/4+moveToRight, y: bottom-w*7+w/4+1)
        } else {
            resultLabel.frame = CGRect.init(x: 0, y: 0, width: wid, height: w-10)
            resultLabel.center = CGPoint.init(x: w*5/2+moveToRight, y: bottom-w*6+10)
            
            memoryLabel.frame = CGRect.init(x: 0, y: 0, width: wid/2, height: w/2-2)
            memoryLabel.center = CGPoint.init(x: w*7/2+moveToRight, y: bottom-w*7+w/16*7+1)
            
            memoryMark.frame = CGRect.init(x: 0, y: 0, width: wid/4, height: w/2-2)
            memoryMark.center = CGPoint.init(x: wid/4+moveToRight, y: bottom-w*7+w/16*7+1)
        }
    }

    private func getLastChar() -> Character {
        return resultLabel.text?.last ?? "0"
    }
    
    private func setNumberButtons(wid: CGFloat, hei: CGFloat) {
        let w = wid/5
        let bottom = hei-50-w/2
        let rad = (w-10)/2 - 2
        for i in 0..<10 {
            let numButton = UIButton(type: UIButton.ButtonType.system)
            numButton.tag = i+1
            numButton.setTitle(String(i), for: UIControl.State.normal)
            numButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            numButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
            numButton.backgroundColor = self.buttonColorGreen
            numButton.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
            numButton.layer.cornerRadius = rad
            numButton.layer.masksToBounds = false
            numButton.clipsToBounds = false
            numButton.layer.shadowColor = UIColor.white.cgColor
            numButton.layer.shadowOffset = CGSize(width: 2, height: 2)
            numButton.layer.shadowRadius = 4.0
            numButton.layer.shadowOpacity = 0.4
            numButton.addTarget(self, action: #selector(numberButtonEvent(_:)), for: UIControl.Event.touchUpInside)
            self.view.addSubview(numButton)
        }
        if let button0 = self.view.viewWithTag(1) {
            button0.center = CGPoint(x: w/2*3+moveToRight, y: bottom)
        }
        if let button1 = self.view.viewWithTag(2) {
            button1.center = CGPoint(x: w/2+moveToRight, y: bottom-w)
        }
        if let button2 = self.view.viewWithTag(3) {
            button2.center = CGPoint(x: w/2*3+moveToRight, y: bottom-w)
        }
        if let button3 = self.view.viewWithTag(4) {
            button3.center = CGPoint(x: w/2*5+moveToRight, y: bottom-w)
        }
        if let button4 = self.view.viewWithTag(5) {
            button4.center = CGPoint(x: w/2+moveToRight, y: bottom-w*2)
        }
        if let button5 = self.view.viewWithTag(6) {
            button5.center = CGPoint(x: w/2*3+moveToRight, y: bottom-w*2)
        }
        if let button6 = self.view.viewWithTag(7) {
            button6.center = CGPoint(x: w/2*5+moveToRight, y: bottom-w*2)
        }
        if let button7 = self.view.viewWithTag(8) {
            button7.center = CGPoint(x: w/2+moveToRight, y: bottom-w*3)
        }
        if let button8 = self.view.viewWithTag(9) {
            button8.center = CGPoint(x: w/2*3+moveToRight, y: bottom-w*3)
        }
        if let button9 = self.view.viewWithTag(10) {
            button9.center = CGPoint(x: w/2*5+moveToRight, y: bottom-w*3)
        }
    }
    
}

extension ViewController {
    
    private func returnBaseButton(tag: Int, title: String, color: UIColor, rad: CGFloat) -> UIButton {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        button.tag = tag
        button.setTitle(title, for: UIControl.State.normal)
        button.backgroundColor = color
        button.layer.cornerRadius = rad
        button.addTarget(self, action: #selector(operationButtonEvent(_:)), for: UIControl.Event.touchUpInside)
        return button
    }
    
    private func setupOperationButtonsFormarHalf(wid: CGFloat, hei: CGFloat) {
        let w = wid/5
        let bottom = hei-50-w/2
        let rad = (w-10)/2 - 2
        
        let buttonC = self.returnBaseButton(tag: 11, title: "C", color: self.buttonColorDarkGray, rad: rad)
        buttonC.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonC.center = CGPoint(x: w/2+moveToRight, y: bottom)
        self.view.addSubview(buttonC)
        
        let buttonP = self.returnBaseButton(tag: 12, title: ".", color: self.buttonColorDarkGray, rad: rad)
        buttonP.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonP.center = CGPoint(x: w/2*5+moveToRight, y: bottom)
        self.view.addSubview(buttonP)
        
        let buttonE = self.returnBaseButton(tag: 13, title: "=", color: self.buttonColorCream, rad: rad)
        buttonE.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonE.center = CGPoint(x: w/2*7+moveToRight, y: bottom)
        self.view.addSubview(buttonE)
        
        let buttonA = self.returnBaseButton(tag: 14, title: "+", color: self.buttonColorCream, rad: rad)
        buttonA.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonA.center = CGPoint(x: w/2*7+moveToRight, y: bottom-w)
        self.view.addSubview(buttonA)
        
        let buttonS = self.returnBaseButton(tag: 15, title: "-", color: self.buttonColorCream, rad: rad)
        buttonS.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonS.center = CGPoint(x: w/2*7+moveToRight, y: bottom-w*2)
        self.view.addSubview(buttonS)
        
        let buttonM = self.returnBaseButton(tag: 16, title: "×", color: self.buttonColorCream, rad: rad)
        buttonM.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonM.center = CGPoint(x: w/2*7+moveToRight, y: bottom-w*3)
        self.view.addSubview(buttonM)
        
        let buttonAC = self.returnBaseButton(tag: 17, title: "AC", color: self.buttonColorDarkGray, rad: rad)
        buttonAC.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonAC.center = CGPoint(x: w/2+moveToRight, y: bottom-w*4)
        self.view.addSubview(buttonAC)
        
        let buttonPM = self.returnBaseButton(tag: 18, title: "±", color: self.buttonColorDarkGray, rad: rad)
        buttonPM.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonPM.center = CGPoint(x: w/2*3+moveToRight, y: bottom-w*4)
        self.view.addSubview(buttonPM)
        
        let buttonSU = self.returnBaseButton(tag: 19, title: "%", color: self.buttonColorDarkGray, rad: rad)
        buttonSU.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonSU.center = CGPoint(x: w/2*5+moveToRight, y: bottom-w*4)
        self.view.addSubview(buttonSU)
    }
    
    private func setupOperationButtonsLatterHalf(wid: CGFloat, hei: CGFloat) {
        let w = wid/5
        let bottom = hei-50-w/2
        let rad = (w-10)/2 - 2
        
        let buttonD = self.returnBaseButton(tag: 20, title: "÷", color: self.buttonColorCream, rad: rad)
        buttonD.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonD.center = CGPoint(x: w/2*7+moveToRight, y: bottom-w*4)
        self.view.addSubview(buttonD)
        
        let buttonR = self.returnBaseButton(tag: 21, title: "√", color: self.buttonColorLightGray, rad: rad)
        buttonR.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonR.center = CGPoint(x: w/2*9+moveToRight, y: bottom)
        self.view.addSubview(buttonR)
        
        let buttonFactorial = self.returnBaseButton(tag: 22, title: "!", color: self.buttonColorLightGray, rad: rad)
        buttonFactorial.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonFactorial.center = CGPoint(x: w/2*9+moveToRight, y: bottom-w)
        self.view.addSubview(buttonFactorial)
        
        let buttonReciprocal = self.returnBaseButton(tag: 23, title: "1/x", color: self.buttonColorLightGray, rad: rad)
        buttonReciprocal.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonReciprocal.center = CGPoint(x: w/2*9+moveToRight, y: bottom-w*2)
        self.view.addSubview(buttonReciprocal)
        
        let buttonPower = self.returnBaseButton(tag: 24, title: "^x", color: self.buttonColorLightGray, rad: rad)
        buttonPower.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonPower.center = CGPoint(x: w/2*9+moveToRight, y: bottom-w*3)
        self.view.addSubview(buttonPower)
        
        let buttonTenPower = self.returnBaseButton(tag: 25, title: "10^x", color: self.buttonColorLightGray, rad: rad)
        buttonTenPower.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonTenPower.center = CGPoint(x: w/2*9+moveToRight, y: bottom-w*4)
        self.view.addSubview(buttonTenPower)
        
        let buttonMC = self.returnBaseButton(tag: 26, title: "mc", color: self.buttonColorLightGray, rad: rad)
        buttonMC.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonMC.center = CGPoint(x: w/2+moveToRight, y: bottom-w*5)
        self.view.addSubview(buttonMC)
        
        let buttonMA = self.returnBaseButton(tag: 27, title: "m+", color: self.buttonColorLightGray, rad: rad)
        buttonMA.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonMA.center = CGPoint(x: w/2*3+moveToRight, y: bottom-w*5)
        self.view.addSubview(buttonMA)
        
        let buttonMS = self.returnBaseButton(tag: 28, title: "m-", color: self.buttonColorLightGray, rad: rad)
        buttonMS.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonMS.center = CGPoint(x: w/2*5+moveToRight, y: bottom-w*5)
        self.view.addSubview(buttonMS)
        
        let buttonMR = self.returnBaseButton(tag: 29, title: "mr", color: self.buttonColorLightGray, rad: rad)
        buttonMR.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonMR.center = CGPoint(x: w/2*7+moveToRight, y: bottom-w*5)
        self.view.addSubview(buttonMR)
        
        let buttonHatena = self.returnBaseButton(tag: 30, title: "?", color: self.buttonColorLightGray, rad: rad)
        buttonHatena.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonHatena.center = CGPoint(x: w/2*9+moveToRight, y: bottom-w*5)
        self.view.addSubview(buttonHatena)
    }
    
}

extension ViewController: GADBannerViewDelegate {
    
    private func setAdvertisement() {
        self.topBannerView = GADBannerView(adSize: kGADAdSizeBanner)
        self.topBannerView.adUnitID = PSCStringStorage.init().TOP_AD_UNIT_ID
        self.topBannerView.rootViewController = self
        self.topBannerView.load(GADRequest())
        self.topBannerView.delegate = self
        self.topBannerView.center.x = self.view.center.x
        self.topAdvertisementView.addSubview(self.topBannerView)
        
        self.bottomBannerView = GADBannerView(adSize: kGADAdSizeBanner)
        self.bottomBannerView.adUnitID = PSCStringStorage.init().BOTTOM_AD_UNIT_ID
        self.bottomBannerView.rootViewController = self
        self.bottomBannerView.load(GADRequest())
        self.bottomBannerView.delegate = self
        self.bottomBannerView.center.x = self.view.center.x
        self.bottomAdvertisementView.addSubview(self.bottomBannerView)
    }
    
}
