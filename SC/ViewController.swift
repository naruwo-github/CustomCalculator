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
    
    @IBOutlet private weak var topAdvertisementView: UIView!
    @IBOutlet private weak var bottomAdvertisementView: UIView!
    
    var topBannerView: GADBannerView!
    var bottomBannerView: GADBannerView!
    let resultLabel: UILabel = UILabel()
    var numOnScreen: Float = 0
    var preNum: Float = 0
    var canCalculate: Bool = false
    var operationNum: Int = 0
    var moveToRight: CGFloat = 0
    let memoryLabel: UILabel = UILabel()
    var memoryNumOnScreen: Float = 0
    let memoryMark = UILabel()
    let url = NSURL(string: "https://chan-naru.hatenablog.com/entry/2019/10/27/141656")
    
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
    
    @objc private func numberButtonEvent(_ sender: UIButton) {
        if canCalculate == true || resultLabel.text == "0" {
            resultLabel.text = String(sender.tag-1)
            numOnScreen = NSString(string: resultLabel.text!).floatValue
            canCalculate = false
        } else {
            resultLabel.text = resultLabel.text! + String(sender.tag-1)
            numOnScreen = NSString(string: resultLabel.text!).floatValue
        }
    }
    
    @objc func operationButtonEvent(_ sender: UIButton) {
        if sender.tag < 20 {
            self.operationButtonEventLowerTwenty(sender: sender)
        } else {
            self.operationButtonEventUpperTwenty(sender: sender)
        }
    }
    
    private func operationButtonEventLowerTwenty(sender: UIButton) {
        if sender.tag == 11 {
            //C
            if resultLabel.text!.count > 1 {
                _ = resultLabel.text!.popLast()
                numOnScreen = NSString(string: resultLabel.text!).floatValue
            } else {
                resultLabel.text = "0"
                numOnScreen = 0
            }
        } else if sender.tag == 12 {
            //Point
            if getLastChar() != "." {
                resultLabel.text?.append(".")
            } else {
                _ = resultLabel.text?.popLast()
            }
            //preNum = NSString(string: resultLabel.text!).floatValue
        } else if sender.tag == 13 {
            //=
            calculateOperation()
        } else if sender.tag == 14 {
            //+
            calculateOperation()
            //最後がoperationじゃないかの確認
            if getLastChar() >= "0" && getLastChar() <= "9" {
            } else {
                _ = resultLabel.text?.popLast()
            }
            preNum = NSString(string: resultLabel.text!).floatValue
            resultLabel.text?.append("+")
            operationNum = sender.tag
            canCalculate = true
        } else if sender.tag == 15 {
            //-
            calculateOperation()
            //最後がoperationじゃないかの確認
            if getLastChar() >= "0" && getLastChar() <= "9" {
            } else {
                _ = resultLabel.text?.popLast()
            }
            preNum = NSString(string: resultLabel.text!).floatValue
            resultLabel.text?.append("-")
            operationNum = sender.tag
            canCalculate = true
        } else if sender.tag == 16 {
            //×
            calculateOperation()
            //最後がoperationじゃないかの確認
            if getLastChar() >= "0" && getLastChar() <= "9" {
            } else {
                _ = resultLabel.text?.popLast()
            }
            preNum = NSString(string: resultLabel.text!).floatValue
            resultLabel.text?.append("×")
            operationNum = sender.tag
            canCalculate = true
        } else if sender.tag == 17 {
            //AC
            resultLabel.text = "0"
            preNum = 0
            numOnScreen = 0
            operationNum = 0
        } else if sender.tag == 18 {
            //+/-
            preNum = NSString(string: resultLabel.text!).floatValue
            var tmp = NSString(string: resultLabel.text!).floatValue
            tmp *= -1.0
            numOnScreen = tmp
            resultLabel.text = String(tmp)
        } else if sender.tag == 19 {
            //%
            calculateOperation()
            //最後がoperationじゃないかの確認
            if getLastChar() >= "0" && getLastChar() <= "9" {
            } else {
                _ = resultLabel.text?.popLast()
            }
            preNum = NSString(string: resultLabel.text!).floatValue
            resultLabel.text?.append("%")
            operationNum = sender.tag
            canCalculate = true
        }
    }
    
    private func operationButtonEventUpperTwenty(sender: UIButton) {
        if sender.tag == 20 {
            //÷
            calculateOperation()
            //最後がoperationじゃないかの確認
            if getLastChar() >= "0" && getLastChar() <= "9" {
            } else {
                _ = resultLabel.text?.popLast()
            }
            preNum = NSString(string: resultLabel.text!).floatValue
            resultLabel.text?.append("÷")
            operationNum = sender.tag
            canCalculate = true
        } else if sender.tag == 21 {
            //√
            //最後がoperationじゃないかの確認
            if getLastChar() >= "0" && getLastChar() <= "9" {
                preNum = NSString(string: resultLabel.text!).floatValue
                resultLabel.text = String(sqrtf(numOnScreen))
                numOnScreen = NSString(string: resultLabel.text!).floatValue
            } else {
                _ = resultLabel.text?.popLast()
            }
        } else if sender.tag == 22 {
            //!
            //最後がoperationじゃないかの確認
            if resultLabel.text == "0" || resultLabel.text == "0.0" {
            } else {
                preNum = NSString(string: resultLabel.text!).floatValue
                let roop = Int(numOnScreen)
                var ans = 1
                for i in 0..<roop {
                    ans *= i+1
                }
                resultLabel.text = String(ans)
                numOnScreen = NSString(string: resultLabel.text!).floatValue
            }
        } else if sender.tag == 23 {
            //1/x
            //最後がoperationじゃないかの確認
            if resultLabel.text == "0" || resultLabel.text == "0.0" {
            } else {
                preNum = NSString(string: resultLabel.text!).floatValue
                resultLabel.text = String(1/numOnScreen)
                numOnScreen = NSString(string: resultLabel.text!).floatValue
            }
        } else if sender.tag == 24 {
            //^x
            calculateOperation()
            //最後がoperationじゃないかの確認
            if getLastChar() >= "0" && getLastChar() <= "9" {
            } else {
                _ = resultLabel.text?.popLast()
            }
            preNum = NSString(string: resultLabel.text!).floatValue
            resultLabel.text?.append("^")
            operationNum = sender.tag
            canCalculate = true
        } else if sender.tag == 25 {
            //10^x
            //最後がoperationじゃないかの確認
            if resultLabel.text == "0" || resultLabel.text == "0.0" {
            } else {
                preNum = NSString(string: resultLabel.text!).floatValue
                resultLabel.text = String(powf(10, numOnScreen))
                numOnScreen = NSString(string: resultLabel.text!).floatValue
            }
        } else if sender.tag == 26 {
            //mc
            memoryNumOnScreen = 0
            memoryLabel.text = String(memoryNumOnScreen)
        } else if sender.tag == 27 {
            //m+
            memoryNumOnScreen += numOnScreen
            memoryLabel.text = String(memoryNumOnScreen)
        } else if sender.tag == 28 {
            //m-
            memoryNumOnScreen -= numOnScreen
            memoryLabel.text = String(memoryNumOnScreen)
        } else if sender.tag == 29 {
            //mr
            numOnScreen = memoryNumOnScreen
            resultLabel.text = String(numOnScreen)
        } else if sender.tag == 30 {
            //Hatena Button
            if UIApplication.shared.canOpenURL(url! as URL) {
                UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
            }
        }
    }
    
    private func calculateOperation() {
        if operationNum == 14 {
            resultLabel.text = String(preNum + numOnScreen)
            numOnScreen += preNum
        } else if operationNum == 15 {
            resultLabel.text = String(preNum - numOnScreen)
            numOnScreen -= preNum
        } else if operationNum == 16 {
            resultLabel.text = String(preNum * numOnScreen)
            numOnScreen *= preNum
        } else if operationNum == 19 {
            resultLabel.text = String(preNum.truncatingRemainder(dividingBy: numOnScreen))
            numOnScreen = preNum.truncatingRemainder(dividingBy: numOnScreen)
        } else if operationNum == 20 {
            resultLabel.text = String(preNum / numOnScreen)
            numOnScreen /= preNum
        } else if operationNum == 24 {
            resultLabel.text = String(powf(preNum, numOnScreen))
            numOnScreen = powf(preNum, numOnScreen)
        }
        operationNum = 0
    }
    
    private func setLabels(wid: CGFloat, hei: CGFloat) {
        //2labels are implemented
        let w = wid/5
        let bottom = hei-50-w/2
        //result label
        resultLabel.backgroundColor = UIColor.black
        resultLabel.textColor = UIColor.white
        resultLabel.text = "0"
        resultLabel.textAlignment = NSTextAlignment.right
        resultLabel.font = UIFont.systemFont(ofSize: 80)
        resultLabel.adjustsFontSizeToFitWidth = true
        self.view.addSubview(resultLabel)
        //memory label
        memoryLabel.backgroundColor = UIColor.black
        memoryLabel.textColor = UIColor.white
        memoryLabel.text = "0"
        memoryLabel.textAlignment = NSTextAlignment.right
        memoryLabel.font = UIFont.systemFont(ofSize: 40)
        memoryLabel.adjustsFontSizeToFitWidth = true
        self.view.addSubview(memoryLabel)
        //memory text
        memoryMark.backgroundColor = UIColor.black
        memoryMark.textColor = UIColor.white
        memoryMark.font = UIFont.systemFont(ofSize: 20)
        memoryMark.text = "Memory"
        self.view.addSubview(memoryMark)
        if UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20 {
            //weather iphone is X or not
            //result label
            resultLabel.frame = CGRect.init(x: 0, y: 0, width: wid, height: w)
            resultLabel.center = CGPoint.init(x: w*5/2+moveToRight, y: bottom-w*6)
            //memory label
            memoryLabel.frame = CGRect.init(x: 0, y: 0, width: wid/2, height: w/2-2)
            memoryLabel.center = CGPoint.init(x: w*7/2+moveToRight, y: bottom-w*7+w/4+1)
            //memory text
            memoryMark.frame = CGRect.init(x: 0, y: 0, width: wid/4, height: w/2-2)
            memoryMark.center = CGPoint.init(x: wid/4+moveToRight, y: bottom-w*7+w/4+1)
        } else {
            //result label
            resultLabel.frame = CGRect.init(x: 0, y: 0, width: wid, height: w-10)
            resultLabel.center = CGPoint.init(x: w*5/2+moveToRight, y: bottom-w*6+10)
            //memory label
            memoryLabel.frame = CGRect.init(x: 0, y: 0, width: wid/2, height: w/2-2)
            memoryLabel.center = CGPoint.init(x: w*7/2+moveToRight, y: bottom-w*7+w/16*7+1)
            //memory text
            memoryMark.frame = CGRect.init(x: 0, y: 0, width: wid/4, height: w/2-2)
            memoryMark.center = CGPoint.init(x: wid/4+moveToRight, y: bottom-w*7+w/16*7+1)
        }
    }

    private func getLastChar() -> Character {
        return resultLabel.text?.last ?? "0"
    }
    
    private func setNumberButtons(wid: CGFloat, hei: CGFloat) {
        //side length of buttons
        let w = wid/5
        let bottom = hei-50-w/2
        let rad = (w-10)/2 - 2
        //making buttons No.0~9
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
    
    private func setAdvertisement() {
        self.topBannerView = GADBannerView(adSize: kGADAdSizeBanner)
        self.topBannerView.adUnitID = "ca-app-pub-6492692627915720/3353518937"
        self.topBannerView.rootViewController = self
        self.topBannerView.load(GADRequest())
        self.topBannerView.delegate = self
        self.topBannerView.center.x = self.view.center.x
        self.topAdvertisementView.addSubview(self.topBannerView)
        
        self.bottomBannerView = GADBannerView(adSize: kGADAdSizeBanner)
        self.bottomBannerView.adUnitID = "ca-app-pub-6492692627915720/2126205352"
        self.bottomBannerView.rootViewController = self
        self.bottomBannerView.load(GADRequest())
        self.bottomBannerView.delegate = self
        self.bottomBannerView.center.x = self.view.center.x
        self.bottomAdvertisementView.addSubview(self.bottomBannerView)
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
    
    fileprivate func setupOperationButtonsFormarHalf(wid: CGFloat, hei: CGFloat) {
        let w = wid/5
        let bottom = hei-50-w/2
        let rad = (w-10)/2 - 2
        //Pop last charactor
        let buttonC = self.returnBaseButton(rad: rad)
        buttonC.tag = 11
        buttonC.setTitle("C", for: UIControl.State.normal)
        buttonC.backgroundColor = UIColor.init(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        buttonC.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonC.center = CGPoint(x: w/2+moveToRight, y: bottom)
        self.view.addSubview(buttonC)
        //Point button ...
        let buttonP = self.returnBaseButton(rad: rad)
        buttonP.tag = 12
        buttonP.setTitle(".", for: UIControl.State.normal)
        buttonP.backgroundColor = UIColor.init(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        buttonP.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonP.center = CGPoint(x: w/2*5+moveToRight, y: bottom)
        self.view.addSubview(buttonP)
        //Equal button
        let buttonE = self.returnBaseButton(rad: rad)
        buttonE.tag = 13
        buttonE.setTitle("=", for: UIControl.State.normal)
        buttonE.backgroundColor = UIColor.init(red: 1, green: 1, blue: 0.8, alpha: 1)
        buttonE.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonE.center = CGPoint(x: w/2*7+moveToRight, y: bottom)
        self.view.addSubview(buttonE)
        //Add button
        let buttonA = self.returnBaseButton(rad: rad)
        buttonA.tag = 14
        buttonA.setTitle("+", for: UIControl.State.normal)
        buttonA.backgroundColor = UIColor.init(red: 1, green: 1, blue: 0.8, alpha: 1)
        buttonA.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonA.center = CGPoint(x: w/2*7+moveToRight, y: bottom-w)
        self.view.addSubview(buttonA)
        //Sub button
        let buttonS = self.returnBaseButton(rad: rad)
        buttonS.tag = 15
        buttonS.setTitle("-", for: UIControl.State.normal)
        buttonS.backgroundColor = UIColor.init(red: 1, green: 1, blue: 0.8, alpha: 1)
        buttonS.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonS.center = CGPoint(x: w/2*7+moveToRight, y: bottom-w*2)
        self.view.addSubview(buttonS)
        //Multiply
        let buttonM = self.returnBaseButton(rad: rad)
        buttonM.tag = 16
        buttonM.setTitle("×", for: UIControl.State.normal)
        buttonM.backgroundColor = UIColor.init(red: 1, green: 1, blue: 0.8, alpha: 1)
        buttonM.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonM.center = CGPoint(x: w/2*7+moveToRight, y: bottom-w*3)
        self.view.addSubview(buttonM)
        //All Clear button
        let buttonAC = self.returnBaseButton(rad: rad)
        buttonAC.tag = 17
        buttonAC.setTitle("AC", for: UIControl.State.normal)
        buttonAC.backgroundColor = UIColor.init(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        buttonAC.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonAC.center = CGPoint(x: w/2+moveToRight, y: bottom-w*4)
        self.view.addSubview(buttonAC)
        //Plus Minus button
        let buttonPM = self.returnBaseButton(rad: rad)
        buttonPM.tag = 18
        buttonPM.setTitle("±", for: UIControl.State.normal)
        buttonPM.backgroundColor = UIColor.init(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        buttonPM.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonPM.center = CGPoint(x: w/2*3+moveToRight, y: bottom-w*4)
        self.view.addSubview(buttonPM)
        //Surplus button
        let buttonSU = self.returnBaseButton(rad: rad)
        buttonSU.tag = 19
        buttonSU.setTitle("%", for: UIControl.State.normal)
        buttonSU.backgroundColor = UIColor.init(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        buttonSU.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonSU.center = CGPoint(x: w/2*5+moveToRight, y: bottom-w*4)
        self.view.addSubview(buttonSU)
    }
    
    fileprivate func setupOperationButtonsLatterHalf(wid: CGFloat, hei: CGFloat) {
        let w = wid/5
        let bottom = hei-50-w/2
        let rad = (w-10)/2 - 2
        //Division
        let buttonD = self.returnBaseButton(rad: rad)
        buttonD.tag = 20
        buttonD.setTitle("÷", for: UIControl.State.normal)
        buttonD.backgroundColor = UIColor.init(red: 1, green: 1, blue: 0.8, alpha: 1)
        buttonD.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonD.center = CGPoint(x: w/2*7+moveToRight, y: bottom-w*4)
        self.view.addSubview(buttonD)
        //√
        let buttonR = self.returnBaseButton(rad: rad)
        buttonR.tag = 21
        buttonR.setTitle("√", for: UIControl.State.normal)
        buttonR.backgroundColor = UIColor.init(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        buttonR.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonR.center = CGPoint(x: w/2*9+moveToRight, y: bottom)
        self.view.addSubview(buttonR)
        //!
        let buttonFactorial = self.returnBaseButton(rad: rad)
        buttonFactorial.tag = 22
        buttonFactorial.setTitle("!", for: UIControl.State.normal)
        buttonFactorial.backgroundColor = UIColor.init(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        buttonFactorial.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonFactorial.center = CGPoint(x: w/2*9+moveToRight, y: bottom-w)
        self.view.addSubview(buttonFactorial)
        //1/x
        let buttonReciprocal = self.returnBaseButton(rad: rad)
        buttonReciprocal.tag = 23
        buttonReciprocal.setTitle("1/x", for: UIControl.State.normal)
        buttonReciprocal.backgroundColor = UIColor.init(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        buttonReciprocal.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonReciprocal.center = CGPoint(x: w/2*9+moveToRight, y: bottom-w*2)
        self.view.addSubview(buttonReciprocal)
        //^x
        let buttonPower = self.returnBaseButton(rad: rad)
        buttonPower.tag = 24
        buttonPower.setTitle("^x", for: UIControl.State.normal)
        buttonPower.backgroundColor = UIColor.init(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        buttonPower.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonPower.center = CGPoint(x: w/2*9+moveToRight, y: bottom-w*3)
        self.view.addSubview(buttonPower)
        //10^x
        let buttonTenPower = self.returnBaseButton(rad: rad)
        buttonTenPower.tag = 25
        buttonTenPower.setTitle("10^x", for: UIControl.State.normal)
        buttonTenPower.backgroundColor = UIColor.init(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        buttonTenPower.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonTenPower.center = CGPoint(x: w/2*9+moveToRight, y: bottom-w*4)
        self.view.addSubview(buttonTenPower)
        //mc
        let buttonMC = self.returnBaseButton(rad: rad)
        buttonMC.tag = 26
        buttonMC.setTitle("mc", for: UIControl.State.normal)
        buttonMC.backgroundColor = UIColor.init(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        buttonMC.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonMC.center = CGPoint(x: w/2+moveToRight, y: bottom-w*5)
        self.view.addSubview(buttonMC)
        //m+
        let buttonMA = self.returnBaseButton(rad: rad)
        buttonMA.tag = 27
        buttonMA.setTitle("m+", for: UIControl.State.normal)
        buttonMA.backgroundColor = UIColor.init(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        buttonMA.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonMA.center = CGPoint(x: w/2*3+moveToRight, y: bottom-w*5)
        self.view.addSubview(buttonMA)
        //m-
        let buttonMS = self.returnBaseButton(rad: rad)
        buttonMS.tag = 28
        buttonMS.setTitle("m-", for: UIControl.State.normal)
        buttonMS.backgroundColor = UIColor.init(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        buttonMS.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonMS.center = CGPoint(x: w/2*5+moveToRight, y: bottom-w*5)
        self.view.addSubview(buttonMS)
        //mr
        let buttonMR = self.returnBaseButton(rad: rad)
        buttonMR.tag = 29
        buttonMR.setTitle("mr", for: UIControl.State.normal)
        buttonMR.backgroundColor = UIColor.init(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        buttonMR.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonMR.center = CGPoint(x: w/2*7+moveToRight, y: bottom-w*5)
        self.view.addSubview(buttonMR)
        //?
        let buttonHatena = self.returnBaseButton(rad: rad)
        buttonHatena.tag = 30
        buttonHatena.setTitle("?", for: UIControl.State.normal)
        buttonHatena.backgroundColor = UIColor.init(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        buttonHatena.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonHatena.center = CGPoint(x: w/2*9+moveToRight, y: bottom-w*5)
        self.view.addSubview(buttonHatena)
    }
}
