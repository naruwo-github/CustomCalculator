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
    
    // TODO: ボタンやラベル設定のところは、コード削減できないか？
    
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
            numButton.backgroundColor = UIColor.init(red: 0.8, green: 1, blue: 0.8, alpha: 1)
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
    
    private func returnBaseButton(rad: CGFloat) -> UIButton {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        button.layer.cornerRadius = rad
        button.addTarget(self, action: #selector(operationButtonEvent(_:)), for: UIControl.Event.touchUpInside)
        return button
    }
    
    private func setupOperationButtonsFormarHalf(wid: CGFloat, hei: CGFloat) {
        let w = wid/5
        let bottom = hei-50-w/2
        let rad = (w-10)/2 - 2
        
        let buttonC = self.returnBaseButton(rad: rad)
        buttonC.tag = 11
        buttonC.setTitle("C", for: UIControl.State.normal)
        buttonC.backgroundColor = UIColor.init(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        buttonC.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonC.center = CGPoint(x: w/2+moveToRight, y: bottom)
        self.view.addSubview(buttonC)
        
        let buttonP = self.returnBaseButton(rad: rad)
        buttonP.tag = 12
        buttonP.setTitle(".", for: UIControl.State.normal)
        buttonP.backgroundColor = UIColor.init(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        buttonP.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonP.center = CGPoint(x: w/2*5+moveToRight, y: bottom)
        self.view.addSubview(buttonP)
        
        let buttonE = self.returnBaseButton(rad: rad)
        buttonE.tag = 13
        buttonE.setTitle("=", for: UIControl.State.normal)
        buttonE.backgroundColor = UIColor.init(red: 1, green: 1, blue: 0.8, alpha: 1)
        buttonE.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonE.center = CGPoint(x: w/2*7+moveToRight, y: bottom)
        self.view.addSubview(buttonE)
        
        let buttonA = self.returnBaseButton(rad: rad)
        buttonA.tag = 14
        buttonA.setTitle("+", for: UIControl.State.normal)
        buttonA.backgroundColor = UIColor.init(red: 1, green: 1, blue: 0.8, alpha: 1)
        buttonA.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonA.center = CGPoint(x: w/2*7+moveToRight, y: bottom-w)
        self.view.addSubview(buttonA)
        
        let buttonS = self.returnBaseButton(rad: rad)
        buttonS.tag = 15
        buttonS.setTitle("-", for: UIControl.State.normal)
        buttonS.backgroundColor = UIColor.init(red: 1, green: 1, blue: 0.8, alpha: 1)
        buttonS.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonS.center = CGPoint(x: w/2*7+moveToRight, y: bottom-w*2)
        self.view.addSubview(buttonS)
        
        let buttonM = self.returnBaseButton(rad: rad)
        buttonM.tag = 16
        buttonM.setTitle("×", for: UIControl.State.normal)
        buttonM.backgroundColor = UIColor.init(red: 1, green: 1, blue: 0.8, alpha: 1)
        buttonM.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonM.center = CGPoint(x: w/2*7+moveToRight, y: bottom-w*3)
        self.view.addSubview(buttonM)
        
        let buttonAC = self.returnBaseButton(rad: rad)
        buttonAC.tag = 17
        buttonAC.setTitle("AC", for: UIControl.State.normal)
        buttonAC.backgroundColor = UIColor.init(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        buttonAC.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonAC.center = CGPoint(x: w/2+moveToRight, y: bottom-w*4)
        self.view.addSubview(buttonAC)
        
        let buttonPM = self.returnBaseButton(rad: rad)
        buttonPM.tag = 18
        buttonPM.setTitle("±", for: UIControl.State.normal)
        buttonPM.backgroundColor = UIColor.init(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        buttonPM.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonPM.center = CGPoint(x: w/2*3+moveToRight, y: bottom-w*4)
        self.view.addSubview(buttonPM)
        
        let buttonSU = self.returnBaseButton(rad: rad)
        buttonSU.tag = 19
        buttonSU.setTitle("%", for: UIControl.State.normal)
        buttonSU.backgroundColor = UIColor.init(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        buttonSU.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonSU.center = CGPoint(x: w/2*5+moveToRight, y: bottom-w*4)
        self.view.addSubview(buttonSU)
    }
    
    private func setupOperationButtonsLatterHalf(wid: CGFloat, hei: CGFloat) {
        let w = wid/5
        let bottom = hei-50-w/2
        let rad = (w-10)/2 - 2
        
        let buttonD = self.returnBaseButton(rad: rad)
        buttonD.tag = 20
        buttonD.setTitle("÷", for: UIControl.State.normal)
        buttonD.backgroundColor = UIColor.init(red: 1, green: 1, blue: 0.8, alpha: 1)
        buttonD.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonD.center = CGPoint(x: w/2*7+moveToRight, y: bottom-w*4)
        self.view.addSubview(buttonD)
        
        let buttonR = self.returnBaseButton(rad: rad)
        buttonR.tag = 21
        buttonR.setTitle("√", for: UIControl.State.normal)
        buttonR.backgroundColor = UIColor.init(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        buttonR.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonR.center = CGPoint(x: w/2*9+moveToRight, y: bottom)
        self.view.addSubview(buttonR)
        
        let buttonFactorial = self.returnBaseButton(rad: rad)
        buttonFactorial.tag = 22
        buttonFactorial.setTitle("!", for: UIControl.State.normal)
        buttonFactorial.backgroundColor = UIColor.init(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        buttonFactorial.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonFactorial.center = CGPoint(x: w/2*9+moveToRight, y: bottom-w)
        self.view.addSubview(buttonFactorial)
        
        let buttonReciprocal = self.returnBaseButton(rad: rad)
        buttonReciprocal.tag = 23
        buttonReciprocal.setTitle("1/x", for: UIControl.State.normal)
        buttonReciprocal.backgroundColor = UIColor.init(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        buttonReciprocal.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonReciprocal.center = CGPoint(x: w/2*9+moveToRight, y: bottom-w*2)
        self.view.addSubview(buttonReciprocal)
        
        let buttonPower = self.returnBaseButton(rad: rad)
        buttonPower.tag = 24
        buttonPower.setTitle("^x", for: UIControl.State.normal)
        buttonPower.backgroundColor = UIColor.init(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        buttonPower.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonPower.center = CGPoint(x: w/2*9+moveToRight, y: bottom-w*3)
        self.view.addSubview(buttonPower)
        
        let buttonTenPower = self.returnBaseButton(rad: rad)
        buttonTenPower.tag = 25
        buttonTenPower.setTitle("10^x", for: UIControl.State.normal)
        buttonTenPower.backgroundColor = UIColor.init(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        buttonTenPower.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonTenPower.center = CGPoint(x: w/2*9+moveToRight, y: bottom-w*4)
        self.view.addSubview(buttonTenPower)
        
        let buttonMC = self.returnBaseButton(rad: rad)
        buttonMC.tag = 26
        buttonMC.setTitle("mc", for: UIControl.State.normal)
        buttonMC.backgroundColor = UIColor.init(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        buttonMC.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonMC.center = CGPoint(x: w/2+moveToRight, y: bottom-w*5)
        self.view.addSubview(buttonMC)
        
        let buttonMA = self.returnBaseButton(rad: rad)
        buttonMA.tag = 27
        buttonMA.setTitle("m+", for: UIControl.State.normal)
        buttonMA.backgroundColor = UIColor.init(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        buttonMA.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonMA.center = CGPoint(x: w/2*3+moveToRight, y: bottom-w*5)
        self.view.addSubview(buttonMA)
        
        let buttonMS = self.returnBaseButton(rad: rad)
        buttonMS.tag = 28
        buttonMS.setTitle("m-", for: UIControl.State.normal)
        buttonMS.backgroundColor = UIColor.init(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        buttonMS.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonMS.center = CGPoint(x: w/2*5+moveToRight, y: bottom-w*5)
        self.view.addSubview(buttonMS)
        
        let buttonMR = self.returnBaseButton(rad: rad)
        buttonMR.tag = 29
        buttonMR.setTitle("mr", for: UIControl.State.normal)
        buttonMR.backgroundColor = UIColor.init(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        buttonMR.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonMR.center = CGPoint(x: w/2*7+moveToRight, y: bottom-w*5)
        self.view.addSubview(buttonMR)
        
        let buttonHatena = self.returnBaseButton(rad: rad)
        buttonHatena.tag = 30
        buttonHatena.setTitle("?", for: UIControl.State.normal)
        buttonHatena.backgroundColor = UIColor.init(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
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
