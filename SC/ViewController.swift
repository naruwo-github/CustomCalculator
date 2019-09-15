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
    //Advertisement
    var bannerView: GADBannerView!
    
    //Calculation result
    var label: UILabel! = UILabel()
    //Text font size
    var fontSize: CGFloat = 80
    //Displaying result
    var numOnScreen: Float = 0.0
    //Keep current value
    var preNum: Float = 0.0
    //Operation mode flag
    var performingMath: Bool = false
    //Operation mode num
    var operation: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // In this case, we instantiate the banner with desired ad size.
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        addBannerViewToView(bannerView)
        bannerView.adUnitID = "ca-app-pub-6492692627915720/7586468524"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
        
        // Do any additional setup after loading the view.
        let wid = self.view.frame.width
        let hei = self.view.frame.height
        
        //Label setting
        setLabel(w: wid, h: hei)
        //Number button setting
        setElementsNormal(w: wid, h: hei)
        //Operation button setting
        setElementOption(w: wid, h: hei)
        //Scientific Operation button setting
        setElementScientific(w: wid, h: hei)
        
        // 端末回転の通知機能を設定します。
        let action = #selector(orientationDidChange(_:))
        let center = NotificationCenter.default
        let name = UIDevice.orientationDidChangeNotification
        center.addObserver(self, selector: action, name: name, object: nil)
    }
    
    //Label setting method
    func setLabel(w: CGFloat, h: CGFloat) {
        //settings
        let bottom = h - 60
        let wid = w / 8
        
        label.textColor = UIColor.white
        label.text = "0"
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.frame = CGRect(x: 0, y: 0, width: w, height: w/3)
        label.center = CGPoint(x: w/2, y: bottom - wid*11)
        //Right alignment
        label.textAlignment = NSTextAlignment.right
        //Auto arrangement of font size
        label.adjustsFontSizeToFitWidth = true
        self.view.addSubview(label)
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
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
    
    //Callded when umber button pressed
    @objc func numButton(_ sender: UIButton) {
        if performingMath == true || label.text == "0" {
            label.text = String(sender.tag-1)
            numOnScreen = NSString(string: label.text!).floatValue
            performingMath = false
        } else {
            label.text = label.text! + String(sender.tag-1)
            numOnScreen = NSString(string: label.text!).floatValue
        }
    }
    
    //Called operation button pressed
    @objc func otherButton(_ sender: UIButton) {
        if sender.tag == 11 {
            //C
            if label.text!.count > 1 {
                _ = label.text!.popLast()
            } else {
                label.text = "0"
            }
        } else if sender.tag == 12 {
            //Point
            if getLastChar() != "." {
                label.text?.append(".")
            } else {
                _ = label.text?.popLast()
            }
            preNum = NSString(string: label.text!).floatValue
        } else if sender.tag == 13 {
            //=
            if operation == 14 {
                label.text = String(preNum + numOnScreen)
            } else if operation == 15 {
                label.text = String(preNum - numOnScreen)
            } else if operation == 16 {
                label.text = String(preNum * numOnScreen)
            } else if operation == 19 {
                label.text = String(preNum.truncatingRemainder(dividingBy: numOnScreen))
            } else if operation == 20 {
                label.text = String(preNum / numOnScreen)
            }
        } else if sender.tag == 14 {
            //+
            //最後がoperationじゃないかの確認
            if getLastChar() >= "0" && getLastChar() <= "9" {
            } else {
                _ = label.text?.popLast()
            }
            preNum = NSString(string: label.text!).floatValue
            label.text?.append("+")
            operation = sender.tag
            performingMath = true
        } else if sender.tag == 15 {
            //-
            //最後がoperationじゃないかの確認
            if getLastChar() >= "0" && getLastChar() <= "9" {
            } else {
                _ = label.text?.popLast()
            }
            preNum = NSString(string: label.text!).floatValue
            label.text?.append("-")
            operation = sender.tag
            performingMath = true
        } else if sender.tag == 16 {
            //×
            //最後がoperationじゃないかの確認
            if getLastChar() >= "0" && getLastChar() <= "9" {
            } else {
                _ = label.text?.popLast()
            }
            preNum = NSString(string: label.text!).floatValue
            label.text?.append("×")
            operation = sender.tag
            performingMath = true
        } else if sender.tag == 17 {
            //AC
            label.text = "0"
            preNum = 0
            numOnScreen = 0
            operation = 0
        } else if sender.tag == 18 {
            //+/-
            preNum = NSString(string: label.text!).floatValue
            var tmp = NSString(string: label.text!).floatValue
            tmp = tmp * -1.0
            label.text = String(tmp)
        } else if sender.tag == 19 {
            //%
            //最後がoperationじゃないかの確認
            if getLastChar() >= "0" && getLastChar() <= "9" {
            } else {
                _ = label.text?.popLast()
            }
            preNum = NSString(string: label.text!).floatValue
            label.text?.append("%")
            operation = sender.tag
            performingMath = true
        } else if sender.tag == 20 {
            //÷
            //最後がoperationじゃないかの確認
            if getLastChar() >= "0" && getLastChar() <= "9" {
            } else {
                _ = label.text?.popLast()
            }
            preNum = NSString(string: label.text!).floatValue
            label.text?.append("÷")
            operation = sender.tag
            performingMath = true
        } else if sender.tag == 21 {
            //Rad
        } else if sender.tag == 22 {
            //sinh
        } else if sender.tag == 23 {
            //cosh
        } else if sender.tag == 24 {
            //tanh
        } else if sender.tag == 25 {
            //π
        } else if sender.tag == 26 {
            //Rand
        } else if sender.tag == 27 {
            //x!
        } else if sender.tag == 28 {
            //sin
        } else if sender.tag == 29 {
            //cos
        } else if sender.tag == 30 {
            //tan
        } else if sender.tag == 31 {
            //e
        } else if sender.tag == 32 {
            //EE
        } else if sender.tag == 33 {
            //1/x
        } else if sender.tag == 34 {
            //2√x
        } else if sender.tag == 35 {
            //3√x
        } else if sender.tag == 36 {
            //y√x
        } else if sender.tag == 37 {
            //ln
        } else if sender.tag == 38 {
            //log10
        } else if sender.tag == 39 {
            //2nd
        } else if sender.tag == 40 {
            //x^2
        } else if sender.tag == 41 {
            //x^3
        } else if sender.tag == 42 {
            //x^y
        } else if sender.tag == 43 {
            //e^x
        } else if sender.tag == 44 {
            //10^x
        } else if sender.tag == 45 {
            //(
        } else if sender.tag == 46 {
            //)
        } else if sender.tag == 47 {
            //mc
        } else if sender.tag == 48 {
            //m+
        } else if sender.tag == 49 {
            //m-
        } else if sender.tag == 50 {
            //nr
        }
    }
    
    //Get the charactor of end
    func getLastChar() -> Character {
        return label.text?.last ?? "0"
    }
    
    @objc func orientationDidChange(_ notification: NSNotification) {
        // 端末の向きを判定します。
        // 縦向きを検知する場合、
        //   device.orientation.isPortrait
        // を判定します。
        let wid = self.view.frame.width
        let hei = self.view.frame.height
        
        let device = UIDevice.current
        if device.orientation.isLandscape {
            // 横向きの場合
            if self.view.frame.width > self.view.frame.height {
                setLandscape(w: wid, h: hei)
            }
        } else {
            // 縦向きの場合
            if self.view.frame.width < self.view.frame.height {
                setPortrate(w: wid, h: hei)
            }
        }
    }
    
    //Normal Calculator Buttons
    func setElementsNormal(w: CGFloat, h: CGFloat) {
        //buttons size
        let interval: CGFloat = 10
        let side: CGFloat = w/4 - interval*2
        
        let wid = w / 8
        let hei = h - 60
        
        //0
        let button0 = UIButton(type: UIButton.ButtonType.system)
        button0.tag = 1
        button0.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        button0.addTarget(self, action: #selector(numButton(_:)), for: UIControl.Event.touchUpInside)
        button0.setTitle("0", for: UIControl.State.normal)
        button0.setTitleColor(UIColor.black, for: UIControl.State.normal)
        button0.backgroundColor = UIColor.init(red: 0.8, green: 1, blue: 0.8, alpha: 1)
        button0.layer.cornerRadius = 30
        button0.frame = CGRect(x: 0, y: 0, width: side, height: side)
        button0.center = CGPoint(x: wid*3, y: hei - wid)
        self.view.addSubview(button0)
        
        //1
        let button1 = UIButton(type: UIButton.ButtonType.system)
        button1.tag = 2
        button1.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        button1.addTarget(self, action: #selector(numButton(_:)), for: UIControl.Event.touchUpInside)
        button1.setTitle("1", for: UIControl.State.normal)
        button1.setTitleColor(UIColor.black, for: UIControl.State.normal)
        button1.backgroundColor = UIColor.init(red: 0.8, green: 1, blue: 0.8, alpha: 1)
        button1.layer.cornerRadius = 30
        button1.frame = CGRect(x: 0, y: 0, width: side, height: side)
        button1.center = CGPoint(x: wid, y: hei - wid*3)
        self.view.addSubview(button1)
        
        //2
        let button2 = UIButton(type: UIButton.ButtonType.system)
        button2.tag = 3
        button2.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        button2.addTarget(self, action: #selector(numButton(_:)), for: UIControl.Event.touchUpInside)
        button2.setTitle("2", for: UIControl.State.normal)
        button2.setTitleColor(UIColor.black, for: UIControl.State.normal)
        button2.backgroundColor = UIColor.init(red: 0.8, green: 1, blue: 0.8, alpha: 1)
        button2.layer.cornerRadius = 30
        button2.frame = CGRect(x: 0, y: 0, width: side, height: side)
        button2.center = CGPoint(x: wid*3, y: hei - wid*3)
        self.view.addSubview(button2)
        
        //3
        let button3 = UIButton(type: UIButton.ButtonType.system)
        button3.tag = 4
        button3.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        button3.addTarget(self, action: #selector(numButton(_:)), for: UIControl.Event.touchUpInside)
        button3.setTitle("3", for: UIControl.State.normal)
        button3.setTitleColor(UIColor.black, for: UIControl.State.normal)
        button3.backgroundColor = UIColor.init(red: 0.8, green: 1, blue: 0.8, alpha: 1)
        button3.layer.cornerRadius = 30
        button3.frame = CGRect(x: 0, y: 0, width: side, height: side)
        button3.center = CGPoint(x: wid*5, y: hei - wid*3)
        self.view.addSubview(button3)
        
        //4
        let button4 = UIButton(type: UIButton.ButtonType.system)
        button4.tag = 5
        button4.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        button4.addTarget(self, action: #selector(numButton(_:)), for: UIControl.Event.touchUpInside)
        button4.setTitle("4", for: UIControl.State.normal)
        button4.setTitleColor(UIColor.black, for: UIControl.State.normal)
        button4.backgroundColor = UIColor.init(red: 0.8, green: 1, blue: 0.8, alpha: 1)
        button4.layer.cornerRadius = 30
        button4.frame = CGRect(x: 0, y: 0, width: side, height: side)
        button4.center = CGPoint(x: wid, y: hei - wid*5)
        self.view.addSubview(button4)
        
        //5
        let button5 = UIButton(type: UIButton.ButtonType.system)
        button5.tag = 6
        button5.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        button5.addTarget(self, action: #selector(numButton(_:)), for: UIControl.Event.touchUpInside)
        button5.setTitle("5", for: UIControl.State.normal)
        button5.setTitleColor(UIColor.black, for: UIControl.State.normal)
        button5.backgroundColor = UIColor.init(red: 0.8, green: 1, blue: 0.8, alpha: 1)
        button5.layer.cornerRadius = 30
        button5.frame = CGRect(x: 0, y: 0, width: side, height: side)
        button5.center = CGPoint(x: wid*3, y: hei - wid*5)
        self.view.addSubview(button5)
        
        //6
        let button6 = UIButton(type: UIButton.ButtonType.system)
        button6.tag = 7
        button6.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        button6.addTarget(self, action: #selector(numButton(_:)), for: UIControl.Event.touchUpInside)
        button6.setTitle("6", for: UIControl.State.normal)
        button6.setTitleColor(UIColor.black, for: UIControl.State.normal)
        button6.backgroundColor = UIColor.init(red: 0.8, green: 1, blue: 0.8, alpha: 1)
        button6.layer.cornerRadius = 30
        button6.frame = CGRect(x: 0, y: 0, width: side, height: side)
        button6.center = CGPoint(x: wid*5, y: hei - wid*5)
        self.view.addSubview(button6)
        
        //7
        let button7 = UIButton(type: UIButton.ButtonType.system)
        button7.tag = 8
        button7.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        button7.addTarget(self, action: #selector(numButton(_:)), for: UIControl.Event.touchUpInside)
        button7.setTitle("7", for: UIControl.State.normal)
        button7.setTitleColor(UIColor.black, for: UIControl.State.normal)
        button7.backgroundColor = UIColor.init(red: 0.8, green: 1, blue: 0.8, alpha: 1)
        button7.layer.cornerRadius = 30
        button7.frame = CGRect(x: 0, y: 0, width: side, height: side)
        button7.center = CGPoint(x: wid, y: hei - wid*7)
        self.view.addSubview(button7)
        
        //8
        let button8 = UIButton(type: UIButton.ButtonType.system)
        button8.tag = 9
        button8.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        button8.addTarget(self, action: #selector(numButton(_:)), for: UIControl.Event.touchUpInside)
        button8.setTitle("8", for: UIControl.State.normal)
        button8.setTitleColor(UIColor.black, for: UIControl.State.normal)
        button8.backgroundColor = UIColor.init(red: 0.8, green: 1, blue: 0.8, alpha: 1)
        button8.layer.cornerRadius = 30
        button8.frame = CGRect(x: 0, y: 0, width: side, height: side)
        button8.center = CGPoint(x: wid*3, y: hei - wid*7)
        self.view.addSubview(button8)
        
        //9
        let button9 = UIButton(type: UIButton.ButtonType.system)
        button9.tag = 10
        button9.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        button9.addTarget(self, action: #selector(numButton(_:)), for: UIControl.Event.touchUpInside)
        button9.setTitle("9", for: UIControl.State.normal)
        button9.setTitleColor(UIColor.black, for: UIControl.State.normal)
        button9.backgroundColor = UIColor.init(red: 0.8, green: 1, blue: 0.8, alpha: 1)
        button9.layer.cornerRadius = 30
        button9.frame = CGRect(x: 0, y: 0, width: side, height: side)
        button9.center = CGPoint(x: wid*5, y: hei - wid*7)
        self.view.addSubview(button9)
    }
    
    //Not Number Buttons
    func setElementOption(w: CGFloat, h: CGFloat) {
        //button size
        let interval: CGFloat = 10
        let side: CGFloat = w/4 - interval*2
        
        let wid = w / 8
        let hei = h - 60
        
        //C
        let buttonSC = UIButton(type: UIButton.ButtonType.system)
        buttonSC.tag = 11
        buttonSC.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        buttonSC.addTarget(self, action: #selector(otherButton(_:)), for: UIControl.Event.touchUpInside)
        //buttonSC.setTitle("←SC", for: UIControl.State.normal)
        buttonSC.setTitle("C", for: UIControl.State.normal)
        buttonSC.setTitleColor(UIColor.black, for: UIControl.State.normal)
        buttonSC.backgroundColor = UIColor.init(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        buttonSC.layer.cornerRadius = 30
        buttonSC.frame = CGRect(x: 0, y: 0, width: side, height: side)
        buttonSC.center = CGPoint(x: wid, y: hei - wid)
        self.view.addSubview(buttonSC)
        
        //Point
        let buttonPoint = UIButton(type: UIButton.ButtonType.system)
        buttonPoint.tag = 12
        buttonPoint.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        buttonPoint.addTarget(self, action: #selector(otherButton(_:)), for: UIControl.Event.touchUpInside)
        buttonPoint.setTitle(".", for: UIControl.State.normal)
        buttonPoint.setTitleColor(UIColor.black, for: UIControl.State.normal)
        buttonPoint.backgroundColor = UIColor.init(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        buttonPoint.layer.cornerRadius = 30
        buttonPoint.frame = CGRect(x: 0, y: 0, width: side, height: side)
        buttonPoint.center = CGPoint(x: wid*5, y: hei - wid)
        self.view.addSubview(buttonPoint)
        
        //=
        let buttonEqu = UIButton(type: UIButton.ButtonType.system)
        buttonEqu.tag = 13
        buttonEqu.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        buttonEqu.addTarget(self, action: #selector(otherButton(_:)), for: UIControl.Event.touchUpInside)
        buttonEqu.setTitle("=", for: UIControl.State.normal)
        buttonEqu.setTitleColor(UIColor.black, for: UIControl.State.normal)
        buttonEqu.backgroundColor = UIColor.init(red: 0.8, green: 0.8, blue: 0.6, alpha: 1)
        buttonEqu.layer.cornerRadius = 30
        buttonEqu.frame = CGRect(x: 0, y: 0, width: side, height: side)
        buttonEqu.center = CGPoint(x: wid*7, y: hei - wid)
        self.view.addSubview(buttonEqu)
        
        //+
        let buttonAdd = UIButton(type: UIButton.ButtonType.system)
        buttonAdd.tag = 14
        buttonAdd.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        buttonAdd.addTarget(self, action: #selector(otherButton(_:)), for: UIControl.Event.touchUpInside)
        buttonAdd.setTitle("+", for: UIControl.State.normal)
        buttonAdd.setTitleColor(UIColor.black, for: UIControl.State.normal)
        buttonAdd.backgroundColor = UIColor.init(red: 0.8, green: 0.8, blue: 0.6, alpha: 1)
        buttonAdd.layer.cornerRadius = 30
        buttonAdd.frame = CGRect(x: 0, y: 0, width: side, height: side)
        buttonAdd.center = CGPoint(x: wid*7, y: hei - wid*3)
        self.view.addSubview(buttonAdd)
        
        //-
        let buttonSub = UIButton(type: UIButton.ButtonType.system)
        buttonSub.tag = 15
        buttonSub.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        buttonSub.addTarget(self, action: #selector(otherButton(_:)), for: UIControl.Event.touchUpInside)
        buttonSub.setTitle("-", for: UIControl.State.normal)
        buttonSub.setTitleColor(UIColor.black, for: UIControl.State.normal)
        buttonSub.backgroundColor = UIColor.init(red: 0.8, green: 0.8, blue: 0.6, alpha: 1)
        buttonSub.layer.cornerRadius = 30
        buttonSub.frame = CGRect(x: 0, y: 0, width: side, height: side)
        buttonSub.center = CGPoint(x: wid*7, y: hei - wid*5)
        self.view.addSubview(buttonSub)
        
        //×
        let buttonMul = UIButton(type: UIButton.ButtonType.system)
        buttonMul.tag = 16
        buttonMul.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        buttonMul.addTarget(self, action: #selector(otherButton(_:)), for: UIControl.Event.touchUpInside)
        buttonMul.setTitle("×", for: UIControl.State.normal)
        buttonMul.setTitleColor(UIColor.black, for: UIControl.State.normal)
        buttonMul.backgroundColor = UIColor.init(red: 0.8, green: 0.8, blue: 0.6, alpha: 1)
        buttonMul.layer.cornerRadius = 30
        buttonMul.frame = CGRect(x: 0, y: 0, width: side, height: side)
        buttonMul.center = CGPoint(x: wid*7, y: hei - wid*7)
        self.view.addSubview(buttonMul)
        
        //AC
        let buttonAc = UIButton(type: UIButton.ButtonType.system)
        buttonAc.tag = 17
        buttonAc.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        buttonAc.addTarget(self, action: #selector(otherButton(_:)), for: UIControl.Event.touchUpInside)
        buttonAc.setTitle("AC", for: UIControl.State.normal)
        buttonAc.setTitleColor(UIColor.black, for: UIControl.State.normal)
        buttonAc.backgroundColor = UIColor.init(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        buttonAc.layer.cornerRadius = 30
        buttonAc.frame = CGRect(x: 0, y: 0, width: side, height: side)
        buttonAc.center = CGPoint(x: wid, y: hei - wid*9)
        self.view.addSubview(buttonAc)
        
        //±
        let buttonAS = UIButton(type: UIButton.ButtonType.system)
        buttonAS.tag = 18
        buttonAS.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        buttonAS.addTarget(self, action: #selector(otherButton(_:)), for: UIControl.Event.touchUpInside)
        buttonAS.setTitle("+/-", for: UIControl.State.normal)
        buttonAS.setTitleColor(UIColor.black, for: UIControl.State.normal)
        buttonAS.backgroundColor = UIColor.init(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        buttonAS.layer.cornerRadius = 30
        buttonAS.frame = CGRect(x: 0, y: 0, width: side, height: side)
        buttonAS.center = CGPoint(x: wid*3, y: hei - wid*9)
        self.view.addSubview(buttonAS)
        
        //%
        let buttonRem = UIButton(type: UIButton.ButtonType.system)
        buttonRem.tag = 19
        buttonRem.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        buttonRem.addTarget(self, action: #selector(otherButton(_:)), for: UIControl.Event.touchUpInside)
        buttonRem.setTitle("%", for: UIControl.State.normal)
        buttonRem.setTitleColor(UIColor.black, for: UIControl.State.normal)
        buttonRem.backgroundColor = UIColor.init(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        buttonRem.layer.cornerRadius = 30
        buttonRem.frame = CGRect(x: 0, y: 0, width: side, height: side)
        buttonRem.center = CGPoint(x: wid*5, y: hei - wid*9)
        self.view.addSubview(buttonRem)
        
        //÷
        let buttonDiv = UIButton(type: UIButton.ButtonType.system)
        buttonDiv.tag = 20
        buttonDiv.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        buttonDiv.addTarget(self, action: #selector(otherButton(_:)), for: UIControl.Event.touchUpInside)
        buttonDiv.setTitle("÷", for: UIControl.State.normal)
        buttonDiv.setTitleColor(UIColor.black, for: UIControl.State.normal)
        buttonDiv.backgroundColor = UIColor.init(red: 0.8, green: 0.8, blue: 0.6, alpha: 1)
        buttonDiv.layer.cornerRadius = 30
        buttonDiv.frame = CGRect(x: 0, y: 0, width: side, height: side)
        buttonDiv.center = CGPoint(x: wid*7, y: hei - wid*9)
        self.view.addSubview(buttonDiv)
    }
    
    //Scientific calculator operation
    func setElementScientific(w: CGFloat, h: CGFloat) {
        //make buttons of scientific operation
        for index in 21..<51 {
            let button = UIButton(type: UIButton.ButtonType.system)
            button.tag = index
            button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
            //button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.addTarget(self, action: #selector(otherButton(_:)), for: UIControl.Event.touchUpInside)
            button.setTitle("", for: UIControl.State.normal)
            button.setTitleColor(UIColor.black, for: UIControl.State.normal)
            button.backgroundColor = UIColor.init(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
            button.layer.cornerRadius = 30
            button.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            button.center = CGPoint(x: 1000, y: 1000)
            self.view.addSubview(button)
        }
        
        //line1
        if let button21 = self.view.viewWithTag(21) as? UIButton {
            button21.setTitle("Rad", for: UIControl.State.normal)
        }
        if let button22 = self.view.viewWithTag(22) as? UIButton {
            button22.setTitle("sinh", for: UIControl.State.normal)
        }
        if let button23 = self.view.viewWithTag(23) as? UIButton {
            button23.setTitle("cosh", for: UIControl.State.normal)
        }
        if let button24 = self.view.viewWithTag(24) as? UIButton {
            button24.setTitle("tanh", for: UIControl.State.normal)
        }
        if let button25 = self.view.viewWithTag(25) as? UIButton {
            button25.setTitle("π", for: UIControl.State.normal)
        }
        if let button26 = self.view.viewWithTag(26) as? UIButton {
            button26.setTitle("Rand", for: UIControl.State.normal)
        }
        //line2
        if let button27 = self.view.viewWithTag(27) as? UIButton {
            button27.setTitle("x!", for: UIControl.State.normal)
        }
        if let button28 = self.view.viewWithTag(28) as? UIButton {
            button28.setTitle("sin", for: UIControl.State.normal)
        }
        if let button29 = self.view.viewWithTag(29) as? UIButton {
            button29.setTitle("cos", for: UIControl.State.normal)
        }
        if let button30 = self.view.viewWithTag(30) as? UIButton {
            button30.setTitle("tan", for: UIControl.State.normal)
        }
        if let button31 = self.view.viewWithTag(31) as? UIButton {
            button31.setTitle("e", for: UIControl.State.normal)
        }
        if let button32 = self.view.viewWithTag(32) as? UIButton {
            button32.setTitle("EE", for: UIControl.State.normal)
        }
        //line3
        if let button33 = self.view.viewWithTag(33) as? UIButton {
            button33.setTitle("1/x", for: UIControl.State.normal)
        }
        if let button34 = self.view.viewWithTag(34) as? UIButton {
            button34.setTitle("2√x", for: UIControl.State.normal)
        }
        if let button35 = self.view.viewWithTag(35) as? UIButton {
            button35.setTitle("3√x", for: UIControl.State.normal)
        }
        if let button36 = self.view.viewWithTag(36) as? UIButton {
            button36.setTitle("y√x", for: UIControl.State.normal)
        }
        if let button37 = self.view.viewWithTag(37) as? UIButton {
            button37.setTitle("ln", for: UIControl.State.normal)
        }
        if let button38 = self.view.viewWithTag(38) as? UIButton {
            button38.setTitle("log10", for: UIControl.State.normal)
        }
        //line4
        if let button39 = self.view.viewWithTag(39) as? UIButton {
            button39.setTitle("2nd", for: UIControl.State.normal)
        }
        if let button40 = self.view.viewWithTag(40) as? UIButton {
            button40.setTitle("x2", for: UIControl.State.normal)
        }
        if let button41 = self.view.viewWithTag(41) as? UIButton {
            button41.setTitle("x3", for: UIControl.State.normal)
        }
        if let button42 = self.view.viewWithTag(42) as? UIButton {
            button42.setTitle("xy", for: UIControl.State.normal)
        }
        if let button43 = self.view.viewWithTag(43) as? UIButton {
            button43.setTitle("ex", for: UIControl.State.normal)
        }
        if let button44 = self.view.viewWithTag(44) as? UIButton {
            button44.setTitle("10x", for: UIControl.State.normal)
        }
        //line5
        if let button45 = self.view.viewWithTag(45) as? UIButton {
            button45.setTitle("(", for: UIControl.State.normal)
        }
        if let button46 = self.view.viewWithTag(46) as? UIButton {
            button46.setTitle(")", for: UIControl.State.normal)
        }
        if let button47 = self.view.viewWithTag(47) as? UIButton {
            button47.setTitle("mc", for: UIControl.State.normal)
        }
        if let button48 = self.view.viewWithTag(48) as? UIButton {
            button48.setTitle("m+", for: UIControl.State.normal)
        }
        if let button49 = self.view.viewWithTag(49) as? UIButton {
            button49.setTitle("m-", for: UIControl.State.normal)
        }
        if let button50 = self.view.viewWithTag(50) as? UIButton {
            button50.setTitle("mr", for: UIControl.State.normal)
        }
    }
    
    //横向き
    func setLandscape(w: CGFloat, h: CGFloat) {
        //buttons size
        let interval: CGFloat = 3
        let sideWid: CGFloat = w/10 - interval*2
        let sideHei: CGFloat = h/6 - interval*2
        
        let wid = w / 20
        let hei = h / 12
        
        //label position
        label.frame = CGRect(x: 0, y: 0, width: w, height: sideHei)
        label.center = CGPoint(x: w/2, y: h - hei*11)
        
        if let button0 = self.view.viewWithTag(1) as? UIButton {
            button0.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            button0.layer.cornerRadius = 30
            button0.frame = CGRect(x: 0, y: 0, width: sideWid, height: sideHei)
            button0.center = CGPoint(x: wid*3, y: h - hei)
        }
        if let button1 = self.view.viewWithTag(2) as? UIButton {
            button1.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            button1.layer.cornerRadius = 30
            button1.frame = CGRect(x: 0, y: 0, width: sideWid, height: sideHei)
            button1.center = CGPoint(x: wid, y: h - hei*3)
        }
        if let button2 = self.view.viewWithTag(3) as? UIButton {
            button2.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            button2.layer.cornerRadius = 30
            button2.frame = CGRect(x: 0, y: 0, width: sideWid, height: sideHei)
            button2.center = CGPoint(x: wid*3, y: h - hei*3)
        }
        if let button3 = self.view.viewWithTag(4) as? UIButton {
            button3.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            button3.layer.cornerRadius = 30
            button3.frame = CGRect(x: 0, y: 0, width: sideWid, height: sideHei)
            button3.center = CGPoint(x: wid*5, y: h - hei*3)
        }
        if let button4 = self.view.viewWithTag(5) as? UIButton {
            button4.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            button4.layer.cornerRadius = 30
            button4.frame = CGRect(x: 0, y: 0, width: sideWid, height: sideHei)
            button4.center = CGPoint(x: wid, y: h - hei*5)
        }
        if let button5 = self.view.viewWithTag(6) as? UIButton {
            button5.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            button5.layer.cornerRadius = 30
            button5.frame = CGRect(x: 0, y: 0, width: sideWid, height: sideHei)
            button5.center = CGPoint(x: wid*3, y: h - hei*5)
        }
        if let button6 = self.view.viewWithTag(7) as? UIButton {
            button6.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            button6.layer.cornerRadius = 30
            button6.frame = CGRect(x: 0, y: 0, width: sideWid, height: sideHei)
            button6.center = CGPoint(x: wid*5, y: h - hei*5)
        }
        if let button7 = self.view.viewWithTag(8) as? UIButton {
            button7.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            button7.layer.cornerRadius = 30
            button7.frame = CGRect(x: 0, y: 0, width: sideWid, height: sideHei)
            button7.center = CGPoint(x: wid, y: h - hei*7)
        }
        if let button8 = self.view.viewWithTag(9) as? UIButton {
            button8.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            button8.layer.cornerRadius = 30
            button8.frame = CGRect(x: 0, y: 0, width: sideWid, height: sideHei)
            button8.center = CGPoint(x: wid*3, y: h - hei*7)
        }
        if let button9 = self.view.viewWithTag(10) as? UIButton {
            button9.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            button9.layer.cornerRadius = 30
            button9.frame = CGRect(x: 0, y: 0, width: sideWid, height: sideHei)
            button9.center = CGPoint(x: wid*5, y: h - hei*7)
        }
        
        if let buttonC = self.view.viewWithTag(11) as? UIButton {
            buttonC.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            buttonC.layer.cornerRadius = 30
            buttonC.frame = CGRect(x: 0, y: 0, width: sideWid, height: sideHei)
            buttonC.center = CGPoint(x: wid, y: h - hei)
        }
        if let buttonP = self.view.viewWithTag(12) as? UIButton {
            buttonP.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            buttonP.layer.cornerRadius = 30
            buttonP.frame = CGRect(x: 0, y: 0, width: sideWid, height: sideHei)
            buttonP.center = CGPoint(x: wid*5, y: h - hei)
        }
        if let buttonEqu = self.view.viewWithTag(13) as? UIButton {
            buttonEqu.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            buttonEqu.layer.cornerRadius = 30
            buttonEqu.frame = CGRect(x: 0, y: 0, width: sideWid, height: sideHei)
            buttonEqu.center = CGPoint(x: wid*7, y: h - hei)
        }
        if let buttonAdd = self.view.viewWithTag(14) as? UIButton {
            buttonAdd.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            buttonAdd.layer.cornerRadius = 30
            buttonAdd.frame = CGRect(x: 0, y: 0, width: sideWid, height: sideHei)
            buttonAdd.center = CGPoint(x: wid*7, y: h - hei*3)
        }
        if let buttonSub = self.view.viewWithTag(15) as? UIButton {
            buttonSub.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            buttonSub.layer.cornerRadius = 30
            buttonSub.frame = CGRect(x: 0, y: 0, width: sideWid, height: sideHei)
            buttonSub.center = CGPoint(x: wid*7, y: h - hei*5)
        }
        if let buttonMul = self.view.viewWithTag(16) as? UIButton {
            buttonMul.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            buttonMul.layer.cornerRadius = 30
            buttonMul.frame = CGRect(x: 0, y: 0, width: sideWid, height: sideHei)
            buttonMul.center = CGPoint(x: wid*7, y: h - hei*7)
        }
        if let buttonAC = self.view.viewWithTag(17) as? UIButton {
            buttonAC.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            buttonAC.layer.cornerRadius = 30
            buttonAC.frame = CGRect(x: 0, y: 0, width: sideWid, height: sideHei)
            buttonAC.center = CGPoint(x: wid, y: h - hei*9)
        }
        if let buttonAS = self.view.viewWithTag(18) as? UIButton {
            buttonAS.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            buttonAS.layer.cornerRadius = 30
            buttonAS.frame = CGRect(x: 0, y: 0, width: sideWid, height: sideHei)
            buttonAS.center = CGPoint(x: wid*3, y: h - hei*9)
        }
        if let buttonRem = self.view.viewWithTag(19) as? UIButton {
            buttonRem.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            buttonRem.layer.cornerRadius = 30
            buttonRem.frame = CGRect(x: 0, y: 0, width: sideWid, height: sideHei)
            buttonRem.center = CGPoint(x: wid*5, y: h - hei*9)
        }
        if let buttonDiv = self.view.viewWithTag(20) as? UIButton {
            buttonDiv.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            buttonDiv.layer.cornerRadius = 30
            buttonDiv.frame = CGRect(x: 0, y: 0, width: sideWid, height: sideHei)
            buttonDiv.center = CGPoint(x: wid*7, y: h - hei*9)
        }
        
        //line1
        if let button21 = self.view.viewWithTag(21) as? UIButton {
            button21.frame = CGRect(x: 0, y: 0, width: sideWid, height: sideHei)
            button21.center = CGPoint(x: wid*9, y: h - hei)
        }
        if let button22 = self.view.viewWithTag(22) as? UIButton {
            button22.frame = CGRect(x: 0, y: 0, width: sideWid, height: sideHei)
            button22.center = CGPoint(x: wid*11, y: h - hei)
        }
        if let button23 = self.view.viewWithTag(23) as? UIButton {
            button23.frame = CGRect(x: 0, y: 0, width: sideWid, height: sideHei)
            button23.center = CGPoint(x: wid*13, y: h - hei)
        }
        if let button24 = self.view.viewWithTag(24) as? UIButton {
            button24.frame = CGRect(x: 0, y: 0, width: sideWid, height: sideHei)
            button24.center = CGPoint(x: wid*15, y: h - hei)
        }
        if let button25 = self.view.viewWithTag(25) as? UIButton {
            button25.frame = CGRect(x: 0, y: 0, width: sideWid, height: sideHei)
            button25.center = CGPoint(x: wid*17, y: h - hei)
        }
        if let button26 = self.view.viewWithTag(26) as? UIButton {
            button26.frame = CGRect(x: 0, y: 0, width: sideWid, height: sideHei)
            button26.center = CGPoint(x: wid*19, y: h - hei)
        }
        //line2
        if let button27 = self.view.viewWithTag(27) as? UIButton {
            button27.frame = CGRect(x: 0, y: 0, width: sideWid, height: sideHei)
            button27.center = CGPoint(x: wid*9, y: h - hei*3)
        }
        if let button28 = self.view.viewWithTag(28) as? UIButton {
            button28.frame = CGRect(x: 0, y: 0, width: sideWid, height: sideHei)
            button28.center = CGPoint(x: wid*11, y: h - hei*3)
        }
        if let button29 = self.view.viewWithTag(29) as? UIButton {
            button29.frame = CGRect(x: 0, y: 0, width: sideWid, height: sideHei)
            button29.center = CGPoint(x: wid*13, y: h - hei*3)
        }
        if let button30 = self.view.viewWithTag(30) as? UIButton {
            button30.frame = CGRect(x: 0, y: 0, width: sideWid, height: sideHei)
            button30.center = CGPoint(x: wid*15, y: h - hei*3)
        }
        if let button31 = self.view.viewWithTag(31) as? UIButton {
            button31.frame = CGRect(x: 0, y: 0, width: sideWid, height: sideHei)
            button31.center = CGPoint(x: wid*17, y: h - hei*3)
        }
        if let button32 = self.view.viewWithTag(32) as? UIButton {
            button32.frame = CGRect(x: 0, y: 0, width: sideWid, height: sideHei)
            button32.center = CGPoint(x: wid*19, y: h - hei*3)
        }
        //line3
        if let button33 = self.view.viewWithTag(33) as? UIButton {
            button33.frame = CGRect(x: 0, y: 0, width: sideWid, height: sideHei)
            button33.center = CGPoint(x: wid*9, y: h - hei*5)
        }
        if let button34 = self.view.viewWithTag(34) as? UIButton {
            button34.frame = CGRect(x: 0, y: 0, width: sideWid, height: sideHei)
            button34.center = CGPoint(x: wid*11, y: h - hei*5)
        }
        if let button35 = self.view.viewWithTag(35) as? UIButton {
            button35.frame = CGRect(x: 0, y: 0, width: sideWid, height: sideHei)
            button35.center = CGPoint(x: wid*13, y: h - hei*5)
        }
        if let button36 = self.view.viewWithTag(36) as? UIButton {
            button36.frame = CGRect(x: 0, y: 0, width: sideWid, height: sideHei)
            button36.center = CGPoint(x: wid*15, y: h - hei*5)
        }
        if let button37 = self.view.viewWithTag(37) as? UIButton {
            button37.frame = CGRect(x: 0, y: 0, width: sideWid, height: sideHei)
            button37.center = CGPoint(x: wid*17, y: h - hei*5)
        }
        if let button38 = self.view.viewWithTag(38) as? UIButton {
            button38.frame = CGRect(x: 0, y: 0, width: sideWid, height: sideHei)
            button38.center = CGPoint(x: wid*19, y: h - hei*5)
        }
        //line4
        if let button39 = self.view.viewWithTag(39) as? UIButton {
            button39.frame = CGRect(x: 0, y: 0, width: sideWid, height: sideHei)
            button39.center = CGPoint(x: wid*9, y: h - hei*7)
        }
        if let button40 = self.view.viewWithTag(40) as? UIButton {
            button40.frame = CGRect(x: 0, y: 0, width: sideWid, height: sideHei)
            button40.center = CGPoint(x: wid*11, y: h - hei*7)
        }
        if let button41 = self.view.viewWithTag(41) as? UIButton {
            button41.frame = CGRect(x: 0, y: 0, width: sideWid, height: sideHei)
            button41.center = CGPoint(x: wid*13, y: h - hei*7)
        }
        if let button42 = self.view.viewWithTag(42) as? UIButton {
            button42.frame = CGRect(x: 0, y: 0, width: sideWid, height: sideHei)
            button42.center = CGPoint(x: wid*15, y: h - hei*7)
        }
        if let button43 = self.view.viewWithTag(43) as? UIButton {
            button43.frame = CGRect(x: 0, y: 0, width: sideWid, height: sideHei)
            button43.center = CGPoint(x: wid*17, y: h - hei*7)
        }
        if let button44 = self.view.viewWithTag(44) as? UIButton {
            button44.frame = CGRect(x: 0, y: 0, width: sideWid, height: sideHei)
            button44.center = CGPoint(x: wid*19, y: h - hei*7)
        }
        //line5
        if let button45 = self.view.viewWithTag(45) as? UIButton {
            button45.frame = CGRect(x: 0, y: 0, width: sideWid, height: sideHei)
            button45.center = CGPoint(x: wid*9, y: h - hei*9)
        }
        if let button46 = self.view.viewWithTag(46) as? UIButton {
            button46.frame = CGRect(x: 0, y: 0, width: sideWid, height: sideHei)
            button46.center = CGPoint(x: wid*11, y: h - hei*9)
        }
        if let button47 = self.view.viewWithTag(47) as? UIButton {
            button47.frame = CGRect(x: 0, y: 0, width: sideWid, height: sideHei)
            button47.center = CGPoint(x: wid*13, y: h - hei*9)
        }
        if let button48 = self.view.viewWithTag(48) as? UIButton {
            button48.frame = CGRect(x: 0, y: 0, width: sideWid, height: sideHei)
            button48.center = CGPoint(x: wid*15, y: h - hei*9)
        }
        if let button49 = self.view.viewWithTag(49) as? UIButton {
            button49.frame = CGRect(x: 0, y: 0, width: sideWid, height: sideHei)
            button49.center = CGPoint(x: wid*17, y: h - hei*9)
        }
        if let button50 = self.view.viewWithTag(50) as? UIButton {
            button50.frame = CGRect(x: 0, y: 0, width: sideWid, height: sideHei)
            button50.center = CGPoint(x: wid*19, y: h - hei*9)
        }
    }
    
    //縦向き
    func setPortrate(w: CGFloat, h: CGFloat) {
        //buttons size
        let interval: CGFloat = 10
        let side: CGFloat = w/4 - interval*2
        
        let wid = w / 8
        let hei = h - 60
        
        //label position
        label.frame = CGRect(x: 0, y: 0, width: w, height: w/3)
        label.center = CGPoint(x: w/2, y: h - 60 - wid*11)
        
        if let button0 = self.view.viewWithTag(1) as? UIButton {
            button0.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            button0.layer.cornerRadius = 30
            button0.frame = CGRect(x: 0, y: 0, width: side, height: side)
            button0.center = CGPoint(x: wid*3, y: hei - wid)
        }
        if let button1 = self.view.viewWithTag(2) as? UIButton {
            button1.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            button1.layer.cornerRadius = 30
            button1.frame = CGRect(x: 0, y: 0, width: side, height: side)
            button1.center = CGPoint(x: wid, y: hei - wid*3)
        }
        if let button2 = self.view.viewWithTag(3) as? UIButton {
            button2.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            button2.layer.cornerRadius = 30
            button2.frame = CGRect(x: 0, y: 0, width: side, height: side)
            button2.center = CGPoint(x: wid*3, y: hei - wid*3)
        }
        if let button3 = self.view.viewWithTag(4) as? UIButton {
            button3.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            button3.layer.cornerRadius = 30
            button3.frame = CGRect(x: 0, y: 0, width: side, height: side)
            button3.center = CGPoint(x: wid*5, y: hei - wid*3)
        }
        if let button4 = self.view.viewWithTag(5) as? UIButton {
            button4.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            button4.layer.cornerRadius = 30
            button4.frame = CGRect(x: 0, y: 0, width: side, height: side)
            button4.center = CGPoint(x: wid, y: hei - wid*5)
        }
        if let button5 = self.view.viewWithTag(6) as? UIButton {
            button5.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            button5.layer.cornerRadius = 30
            button5.frame = CGRect(x: 0, y: 0, width: side, height: side)
            button5.center = CGPoint(x: wid*3, y: hei - wid*5)
        }
        if let button6 = self.view.viewWithTag(7) as? UIButton {
            button6.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            button6.layer.cornerRadius = 30
            button6.frame = CGRect(x: 0, y: 0, width: side, height: side)
            button6.center = CGPoint(x: wid*5, y: hei - wid*5)
        }
        if let button7 = self.view.viewWithTag(8) as? UIButton {
            button7.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            button7.layer.cornerRadius = 30
            button7.frame = CGRect(x: 0, y: 0, width: side, height: side)
            button7.center = CGPoint(x: wid, y: hei - wid*7)
        }
        if let button8 = self.view.viewWithTag(9) as? UIButton {
            button8.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            button8.layer.cornerRadius = 30
            button8.frame = CGRect(x: 0, y: 0, width: side, height: side)
            button8.center = CGPoint(x: wid*3, y: hei - wid*7)
        }
        if let button9 = self.view.viewWithTag(10) as? UIButton {
            button9.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            button9.layer.cornerRadius = 30
            button9.frame = CGRect(x: 0, y: 0, width: side, height: side)
            button9.center = CGPoint(x: wid*5, y: hei - wid*7)
        }
        
        if let buttonC = self.view.viewWithTag(11) as? UIButton {
            buttonC.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            buttonC.layer.cornerRadius = 30
            buttonC.frame = CGRect(x: 0, y: 0, width: side, height: side)
            buttonC.center = CGPoint(x: wid, y: hei - wid)
        }
        if let buttonP = self.view.viewWithTag(12) as? UIButton {
            buttonP.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            buttonP.layer.cornerRadius = 30
            buttonP.frame = CGRect(x: 0, y: 0, width: side, height: side)
            buttonP.center = CGPoint(x: wid*5, y: hei - wid)
        }
        if let buttonEqu = self.view.viewWithTag(13) as? UIButton {
            buttonEqu.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            buttonEqu.layer.cornerRadius = 30
            buttonEqu.frame = CGRect(x: 0, y: 0, width: side, height: side)
            buttonEqu.center = CGPoint(x: wid*7, y: hei - wid)
        }
        if let buttonAdd = self.view.viewWithTag(14) as? UIButton {
            buttonAdd.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            buttonAdd.layer.cornerRadius = 30
            buttonAdd.frame = CGRect(x: 0, y: 0, width: side, height: side)
            buttonAdd.center = CGPoint(x: wid*7, y: hei - wid*3)
        }
        if let buttonSub = self.view.viewWithTag(15) as? UIButton {
            buttonSub.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            buttonSub.layer.cornerRadius = 30
            buttonSub.frame = CGRect(x: 0, y: 0, width: side, height: side)
            buttonSub.center = CGPoint(x: wid*7, y: hei - wid*5)
        }
        if let buttonMul = self.view.viewWithTag(16) as? UIButton {
            buttonMul.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            buttonMul.layer.cornerRadius = 30
            buttonMul.frame = CGRect(x: 0, y: 0, width: side, height: side)
            buttonMul.center = CGPoint(x: wid*7, y: hei - wid*7)
        }
        if let buttonAC = self.view.viewWithTag(17) as? UIButton {
            buttonAC.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            buttonAC.layer.cornerRadius = 30
            buttonAC.frame = CGRect(x: 0, y: 0, width: side, height: side)
            buttonAC.center = CGPoint(x: wid, y: hei - wid*9)
        }
        if let buttonAS = self.view.viewWithTag(18) as? UIButton {
            buttonAS.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            buttonAS.layer.cornerRadius = 30
            buttonAS.frame = CGRect(x: 0, y: 0, width: side, height: side)
            buttonAS.center = CGPoint(x: wid*3, y: hei - wid*9)
        }
        if let buttonRem = self.view.viewWithTag(19) as? UIButton {
            buttonRem.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            buttonRem.layer.cornerRadius = 30
            buttonRem.frame = CGRect(x: 0, y: 0, width: side, height: side)
            buttonRem.center = CGPoint(x: wid*5, y: hei - wid*9)
        }
        if let buttonDiv = self.view.viewWithTag(20) as? UIButton {
            buttonDiv.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            buttonDiv.layer.cornerRadius = 30
            buttonDiv.frame = CGRect(x: 0, y: 0, width: side, height: side)
            buttonDiv.center = CGPoint(x: wid*7, y: hei - wid*9)
        }
        
        //do not display scientific buttons
        for index in 21..<51 {
            if let button = self.view.viewWithTag(index) as? UIButton {
                button.center = CGPoint(x: 1000, y: 1000)
            }
        }
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

