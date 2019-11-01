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
    //settings
    let resultLabel: UILabel = UILabel()
    var numOnScreen: Float = 0
    var preNum: Float = 0
    //operation flag
    var canCalculate: Bool = false
    //operatin number
    var operationNum: Int = 0
    //ipad
    var moveToRight: CGFloat = 0
    //memory
    let memoryLabel: UILabel = UILabel()
    var memoryNumOnScreen: Float = 0
    let memoryMark = UILabel()
    //URL
    let url = NSURL(string: "https://chan-naru.hatenablog.com/entry/2019/10/27/141656")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //========================================================================
        //=====Advertisement=====
        // In this case, we instantiate the banner with desired ad size.
        //top
        topBannerView = GADBannerView(adSize: kGADAdSizeBanner)
        addTopBannerViewToView(topBannerView)
        topBannerView.adUnitID = "ca-app-pub-6492692627915720/3353518937"
        //Test
        //topBannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        topBannerView.rootViewController = self
        topBannerView.load(GADRequest())
        topBannerView.delegate = self
        
        //bottom
        bottomBannerView = GADBannerView(adSize: kGADAdSizeBanner)
        addBottomBannerViewToView(bottomBannerView)
        bottomBannerView.adUnitID = "ca-app-pub-6492692627915720/2126205352"
        //Test
        //bottomBannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bottomBannerView.rootViewController = self
        bottomBannerView.load(GADRequest())
        bottomBannerView.delegate = self
        //========================================================================
        
        var width = self.view.frame.width
        var height = self.view.frame.height
        if UIDevice.current.userInterfaceIdiom == .pad {
            width -= 200
            height -= 20
            moveToRight = width/8
        } else {
            if UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20 {
                //weather iphone is X or not
                height -= 34
            }
        }
        setLabels(wid: width, hei: height)
        setNumberButtons(wid: width, hei: height)
        setOperationButtons(wid: width, hei: height)
    }
    
    //Number button tapped
    @objc func numberButtonEvent(_ sender: UIButton) {
        if canCalculate == true || resultLabel.text == "0" {
            resultLabel.text = String(sender.tag-1)
            numOnScreen = NSString(string: resultLabel.text!).floatValue
            canCalculate = false
        } else {
            resultLabel.text = resultLabel.text! + String(sender.tag-1)
            numOnScreen = NSString(string: resultLabel.text!).floatValue
        }
    }
    
    //Operation button tapped
    @objc func operationButtonEvent(_ sender: UIButton) {
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
            preNum = NSString(string: resultLabel.text!).floatValue
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
            tmp = tmp * -1.0
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
        } else if sender.tag == 20 {
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
            if UIApplication.shared.canOpenURL(url! as URL){
                UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
            }
        }
    }
    
    //calculate operation
    func calculateOperation() {
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
        operationNum = 0;
    }
    
    
    //memory and result label
    func setLabels(wid: CGFloat, hei: CGFloat) {
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

    //Get the end character of result label
    func getLastChar() -> Character {
        return resultLabel.text?.last ?? "0"
    }

    
    //number button
    func setNumberButtons(wid: CGFloat, hei: CGFloat) {
        //side length of buttons
        let w = wid/5
        let bottom = hei-50-w/2
        //making buttons No.0~9
        for i in 0..<10 {
            let numButton = UIButton(type: UIButton.ButtonType.system)
            numButton.tag = i+1
            numButton.setTitle(String(i), for: UIControl.State.normal)
            numButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            numButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
            numButton.backgroundColor = UIColor.init(red: 0.8, green: 1, blue: 0.8, alpha: 1)
            numButton.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
            numButton.layer.cornerRadius = 30
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
    
    //operation button
    func setOperationButtons(wid: CGFloat, hei: CGFloat) {
        //side length of buttons
        let w = wid/5
        let bottom = hei-50-w/2
        
        //making operation buttons
        //Pop last charactor
        let buttonC = UIButton(type: UIButton.ButtonType.system)
        buttonC.tag = 11
        buttonC.setTitle("C", for: UIControl.State.normal)
        buttonC.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        buttonC.setTitleColor(UIColor.black, for: UIControl.State.normal)
        buttonC.backgroundColor = UIColor.init(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        buttonC.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonC.center = CGPoint(x: w/2+moveToRight, y: bottom)
        buttonC.layer.cornerRadius = 30
        buttonC.addTarget(self, action: #selector(operationButtonEvent(_:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(buttonC)
        //Point button ...
        let buttonP = UIButton(type: UIButton.ButtonType.system)
        buttonP.tag = 12
        buttonP.setTitle(".", for: UIControl.State.normal)
        buttonP.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        buttonP.setTitleColor(UIColor.black, for: UIControl.State.normal)
        buttonP.backgroundColor = UIColor.init(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        buttonP.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonP.center = CGPoint(x: w/2*5+moveToRight, y: bottom)
        buttonP.layer.cornerRadius = 30
        buttonP.addTarget(self, action: #selector(operationButtonEvent(_:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(buttonP)
        //Equal button
        let buttonE = UIButton(type: UIButton.ButtonType.system)
        buttonE.tag = 13
        buttonE.setTitle("=", for: UIControl.State.normal)
        buttonE.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        buttonE.setTitleColor(UIColor.black, for: UIControl.State.normal)
        buttonE.backgroundColor = UIColor.init(red: 1, green: 1, blue: 0.8, alpha: 1)
        buttonE.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonE.center = CGPoint(x: w/2*7+moveToRight, y: bottom)
        buttonE.layer.cornerRadius = 30
        buttonE.addTarget(self, action: #selector(operationButtonEvent(_:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(buttonE)
        //Add button
        let buttonA = UIButton(type: UIButton.ButtonType.system)
        buttonA.tag = 14
        buttonA.setTitle("+", for: UIControl.State.normal)
        buttonA.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        buttonA.setTitleColor(UIColor.black, for: UIControl.State.normal)
        buttonA.backgroundColor = UIColor.init(red: 1, green: 1, blue: 0.8, alpha: 1)
        buttonA.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonA.center = CGPoint(x: w/2*7+moveToRight, y: bottom-w)
        buttonA.layer.cornerRadius = 30
        buttonA.addTarget(self, action: #selector(operationButtonEvent(_:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(buttonA)
        //Sub button
        let buttonS = UIButton(type: UIButton.ButtonType.system)
        buttonS.tag = 15
        buttonS.setTitle("-", for: UIControl.State.normal)
        buttonS.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        buttonS.setTitleColor(UIColor.black, for: UIControl.State.normal)
        buttonS.backgroundColor = UIColor.init(red: 1, green: 1, blue: 0.8, alpha: 1)
        buttonS.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonS.center = CGPoint(x: w/2*7+moveToRight, y: bottom-w*2)
        buttonS.layer.cornerRadius = 30
        buttonS.addTarget(self, action: #selector(operationButtonEvent(_:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(buttonS)
        //Multiply
        let buttonM = UIButton(type: UIButton.ButtonType.system)
        buttonM.tag = 16
        buttonM.setTitle("×", for: UIControl.State.normal)
        buttonM.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        buttonM.setTitleColor(UIColor.black, for: UIControl.State.normal)
        buttonM.backgroundColor = UIColor.init(red: 1, green: 1, blue: 0.8, alpha: 1)
        buttonM.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonM.center = CGPoint(x: w/2*7+moveToRight, y: bottom-w*3)
        buttonM.layer.cornerRadius = 30
        buttonM.addTarget(self, action: #selector(operationButtonEvent(_:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(buttonM)
        //All Clear button
        let buttonAC = UIButton(type: UIButton.ButtonType.system)
        buttonAC.tag = 17
        buttonAC.setTitle("AC", for: UIControl.State.normal)
        buttonAC.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        buttonAC.setTitleColor(UIColor.black, for: UIControl.State.normal)
        buttonAC.backgroundColor = UIColor.init(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        buttonAC.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonAC.center = CGPoint(x: w/2+moveToRight, y: bottom-w*4)
        buttonAC.layer.cornerRadius = 30
        buttonAC.addTarget(self, action: #selector(operationButtonEvent(_:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(buttonAC)
        //Plus Minus button
        let buttonPM = UIButton(type: UIButton.ButtonType.system)
        buttonPM.tag = 18
        buttonPM.setTitle("±", for: UIControl.State.normal)
        buttonPM.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        buttonPM.setTitleColor(UIColor.black, for: UIControl.State.normal)
        buttonPM.backgroundColor = UIColor.init(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        buttonPM.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonPM.center = CGPoint(x: w/2*3+moveToRight, y: bottom-w*4)
        buttonPM.layer.cornerRadius = 30
        buttonPM.addTarget(self, action: #selector(operationButtonEvent(_:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(buttonPM)
        //Surplus button
        let buttonSU = UIButton(type: UIButton.ButtonType.system)
        buttonSU.tag = 19
        buttonSU.setTitle("%", for: UIControl.State.normal)
        buttonSU.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        buttonSU.setTitleColor(UIColor.black, for: UIControl.State.normal)
        buttonSU.backgroundColor = UIColor.init(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        buttonSU.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonSU.center = CGPoint(x: w/2*5+moveToRight, y: bottom-w*4)
        buttonSU.layer.cornerRadius = 30
        buttonSU.addTarget(self, action: #selector(operationButtonEvent(_:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(buttonSU)
        //Division
        let buttonD = UIButton(type: UIButton.ButtonType.system)
        buttonD.tag = 20
        buttonD.setTitle("÷", for: UIControl.State.normal)
        buttonD.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        buttonD.setTitleColor(UIColor.black, for: UIControl.State.normal)
        buttonD.backgroundColor = UIColor.init(red: 1, green: 1, blue: 0.8, alpha: 1)
        buttonD.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonD.center = CGPoint(x: w/2*7+moveToRight, y: bottom-w*4)
        buttonD.layer.cornerRadius = 30
        buttonD.addTarget(self, action: #selector(operationButtonEvent(_:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(buttonD)
        //√
        let buttonR = UIButton(type: UIButton.ButtonType.system)
        buttonR.tag = 21
        buttonR.setTitle("√", for: UIControl.State.normal)
        buttonR.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        buttonR.setTitleColor(UIColor.black, for: UIControl.State.normal)
        buttonR.backgroundColor = UIColor.init(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        buttonR.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonR.center = CGPoint(x: w/2*9+moveToRight, y: bottom)
        buttonR.layer.cornerRadius = 30
        buttonR.addTarget(self, action: #selector(operationButtonEvent(_:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(buttonR)
        //!
        let buttonFactorial = UIButton(type: UIButton.ButtonType.system)
        buttonFactorial.tag = 22
        buttonFactorial.setTitle("!", for: UIControl.State.normal)
        buttonFactorial.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        buttonFactorial.setTitleColor(UIColor.black, for: UIControl.State.normal)
        buttonFactorial.backgroundColor = UIColor.init(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        buttonFactorial.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonFactorial.center = CGPoint(x: w/2*9+moveToRight, y: bottom-w)
        buttonFactorial.layer.cornerRadius = 30
        buttonFactorial.addTarget(self, action: #selector(operationButtonEvent(_:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(buttonFactorial)
        //1/x
        let buttonFraction = UIButton(type: UIButton.ButtonType.system)
        buttonFraction.tag = 23
        buttonFraction.setTitle("1/x", for: UIControl.State.normal)
        buttonFraction.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        buttonFraction.setTitleColor(UIColor.black, for: UIControl.State.normal)
        buttonFraction.backgroundColor = UIColor.init(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        buttonFraction.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonFraction.center = CGPoint(x: w/2*9+moveToRight, y: bottom-w*2)
        buttonFraction.layer.cornerRadius = 30
        buttonFraction.addTarget(self, action: #selector(operationButtonEvent(_:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(buttonFraction)
        //^x
        let buttonPower = UIButton(type: UIButton.ButtonType.system)
        buttonPower.tag = 24
        buttonPower.setTitle("^x", for: UIControl.State.normal)
        buttonPower.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        buttonPower.setTitleColor(UIColor.black, for: UIControl.State.normal)
        buttonPower.backgroundColor = UIColor.init(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        buttonPower.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonPower.center = CGPoint(x: w/2*9+moveToRight, y: bottom-w*3)
        buttonPower.layer.cornerRadius = 30
        buttonPower.addTarget(self, action: #selector(operationButtonEvent(_:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(buttonPower)
        //10^x
        let buttonTenPower = UIButton(type: UIButton.ButtonType.system)
        buttonTenPower.tag = 25
        buttonTenPower.setTitle("10^x", for: UIControl.State.normal)
        buttonTenPower.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        buttonTenPower.setTitleColor(UIColor.black, for: UIControl.State.normal)
        buttonTenPower.backgroundColor = UIColor.init(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        buttonTenPower.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonTenPower.center = CGPoint(x: w/2*9+moveToRight, y: bottom-w*4)
        buttonTenPower.layer.cornerRadius = 30
        buttonTenPower.addTarget(self, action: #selector(operationButtonEvent(_:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(buttonTenPower)
        //mc
        let buttonMC = UIButton(type: UIButton.ButtonType.system)
        buttonMC.tag = 26
        buttonMC.setTitle("mc", for: UIControl.State.normal)
        buttonMC.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        buttonMC.setTitleColor(UIColor.black, for: UIControl.State.normal)
        buttonMC.backgroundColor = UIColor.init(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        buttonMC.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonMC.center = CGPoint(x: w/2+moveToRight, y: bottom-w*5)
        buttonMC.layer.cornerRadius = 30
        buttonMC.addTarget(self, action: #selector(operationButtonEvent(_:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(buttonMC)
        //m+
        let buttonMA = UIButton(type: UIButton.ButtonType.system)
        buttonMA.tag = 27
        buttonMA.setTitle("m+", for: UIControl.State.normal)
        buttonMA.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        buttonMA.setTitleColor(UIColor.black, for: UIControl.State.normal)
        buttonMA.backgroundColor = UIColor.init(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        buttonMA.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonMA.center = CGPoint(x: w/2*3+moveToRight, y: bottom-w*5)
        buttonMA.layer.cornerRadius = 30
        buttonMA.addTarget(self, action: #selector(operationButtonEvent(_:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(buttonMA)
        //m-
        let buttonMS = UIButton(type: UIButton.ButtonType.system)
        buttonMS.tag = 28
        buttonMS.setTitle("m-", for: UIControl.State.normal)
        buttonMS.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        buttonMS.setTitleColor(UIColor.black, for: UIControl.State.normal)
        buttonMS.backgroundColor = UIColor.init(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        buttonMS.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonMS.center = CGPoint(x: w/2*5+moveToRight, y: bottom-w*5)
        buttonMS.layer.cornerRadius = 30
        buttonMS.addTarget(self, action: #selector(operationButtonEvent(_:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(buttonMS)
        //mr
        let buttonMR = UIButton(type: UIButton.ButtonType.system)
        buttonMR.tag = 29
        buttonMR.setTitle("mr", for: UIControl.State.normal)
        buttonMR.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        buttonMR.setTitleColor(UIColor.black, for: UIControl.State.normal)
        buttonMR.backgroundColor = UIColor.init(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        buttonMR.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonMR.center = CGPoint(x: w/2*7+moveToRight, y: bottom-w*5)
        buttonMR.layer.cornerRadius = 30
        buttonMR.addTarget(self, action: #selector(operationButtonEvent(_:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(buttonMR)
        //?
        let buttonHatena = UIButton(type: UIButton.ButtonType.system)
        buttonHatena.tag = 30
        buttonHatena.setTitle("?", for: UIControl.State.normal)
        buttonHatena.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        buttonHatena.setTitleColor(UIColor.black, for: UIControl.State.normal)
        buttonHatena.backgroundColor = UIColor.init(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        buttonHatena.frame = CGRect(x: 0, y: 0, width: w-10, height: w-10)
        buttonHatena.center = CGPoint(x: w/2*9+moveToRight, y: bottom-w*5)
        buttonHatena.layer.cornerRadius = 30
        buttonHatena.addTarget(self, action: #selector(operationButtonEvent(_:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(buttonHatena)
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

