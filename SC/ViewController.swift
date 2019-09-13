//
//  ViewController.swift
//  SC
//
//  Created by Narumi Nogawa on 2019/09/08.
//  Copyright © 2019 Narumi Nogawa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
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
        // Do any additional setup after loading the view.
        let wid = self.view.frame.width
        let hei = self.view.frame.height
        
        //Label setting
        setLabel(w: wid, h: hei)
        //Number button setting
        setElementsNormal(w: wid, h: hei)
        //Operation button setting
        setElementOption(w: wid, h: hei)
        
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
            setLandscape(w: wid, h: hei)
        } else {
            // 縦向きの場合
            setPortrate(w: wid, h: hei)
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
    
    //横向き
    func setLandscape(w: CGFloat, h: CGFloat) {
        //buttons size
        let interval: CGFloat = 5
        let side: CGFloat = w/10 - interval*2
        
        let wid = w / 20
        let hei = h
        
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
    }
    
    //縦向き
    func setPortrate(w: CGFloat, h: CGFloat) {
        //buttons size
        let interval: CGFloat = 10
        let side: CGFloat = w/4 - interval*2
        
        let wid = w / 8
        let hei = h - 60
        
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
    }
}

