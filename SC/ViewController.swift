//
//  ViewController.swift
//  SC
//
//  Created by Narumi Nogawa on 2019/09/08.
//  Copyright © 2019 Narumi Nogawa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var label: UILabel! = UILabel()
    var numOnScreen: Double = 0
    var preNum: Double = 0
    var performingMath = false
    var operation = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let wid = self.view.frame.width
        let hei = self.view.frame.height
        
        //settings
        setLabel(w: wid, h: hei)
        setElementsNormal(w: wid, h: hei)
        setElementOption(w: wid, h: hei)
        
        /*
        // 端末回転の通知機能を設定します。
        let action = #selector(orientationDidChange(_:))
        let center = NotificationCenter.default
        let name = UIDevice.orientationDidChangeNotification
        center.addObserver(self, selector: action, name: name, object: nil)
 */
    }
    
    func setLabel(w: CGFloat, h: CGFloat) {
        label.textColor = UIColor.white
        label.text = "0"
        label.font = UIFont.systemFont(ofSize: 100)
        label.frame = CGRect(x: 0, y: 0, width: w, height: w/3)
        //label.backgroundColor = UIColor.gray
        label.center = CGPoint(x: w/2, y: h-50-h*11/16)
        //label.sizeToFit()
        label.textAlignment = NSTextAlignment.right
        self.view.addSubview(label)
    }
    
    @objc func numButton(_ sender: UIButton) {
        if performingMath == true || label.text == "0" {
            label.text = String(sender.tag)
            numOnScreen = Double(label.text!) as! Double
            performingMath = false
        } else {
            label.text = label.text! + String(sender.tag)
            numOnScreen = Double(label.text!) as! Double
        }
        /*
        if(label.text == "0"){
            label.text = String(sender.tag)
        }else{
            label.text?.append(String(sender.tag))
        }
 */
    }
    
    @objc func otherButton(_ sender: UIButton) {
        if(sender.tag == 10){
            //SC
        }else if(sender.tag == 11){
            //Point
            if(getLastChar() != "."){
                label.text?.append(".")
            }else{
                _ = label.text?.popLast()
            }
            preNum = Double(label.text!) as! Double
        }else if(sender.tag == 12){
            //=
            if operation == 13{
                label.text = String(preNum + numOnScreen)
            }else if operation == 14{
                label.text = String(preNum - numOnScreen)
            }else if operation == 15{
                label.text = String(preNum * numOnScreen)
            }else if operation == 18{
                //label.text = String(preNum % numOnScreen)
            }else if operation == 19{
                label.text = String(preNum / numOnScreen)
            }
        }else if(sender.tag == 13){
            //+
            preNum = Double(label.text!) as! Double
            label.text?.append("+")
            operation = sender.tag
            performingMath = true
        }else if(sender.tag == 14){
            //-
            preNum = Double(label.text!) as! Double
            label.text?.append("-")
            operation = sender.tag
            performingMath = true
        }else if(sender.tag == 15){
            //×
            preNum = Double(label.text!) as! Double
            label.text?.append("×")
            operation = sender.tag
            performingMath = true
        }else if(sender.tag == 16){
            //AC
            label.text = "0"
            preNum = 0
            numOnScreen = 0
            operation = 0
        }else if(sender.tag == 17){
            //+/-
            preNum = Double(label.text!) as! Double
            var tmp = Double(label.text!) as! Double
            tmp = tmp * -1.0
            label.text = String(tmp)
        }else if(sender.tag == 18){
            //%
            preNum = Double(label.text!) as! Double
            label.text?.append("%")
            operation = sender.tag
            performingMath = true
        }else if(sender.tag == 19){
            //÷
            preNum = Double(label.text!) as! Double
            label.text?.append("÷")
            operation = sender.tag
            performingMath = true
        }
    }
    
    func getLastChar() -> Character {
        return label.text?.last ?? "0"
    }
    
    /*
    @objc func orientationDidChange(_ notification: NSNotification) {
        // 端末の向きを判定します。
        // 縦向きを検知する場合、
        //   device.orientation.isPortrait
        // を判定します。
        let device = UIDevice.current
        if device.orientation.isLandscape {
            // 横向きの場合
//            print("横向き")
//            print(self.view.frame.width)
//            print(self.view.frame.height)
            setLandscape()
        } else {
            // 縦向きの場合
//            print("縦向き")
//            print(self.view.frame.width)
//            print(self.view.frame.height)
            setPortrate()
        }
    }
 */
    
    //Normal Calculator Buttons
    func setElementsNormal(w: CGFloat, h: CGFloat) {
        //buttons size
        let bw = w / 4 - 20
        let wid = w / 8
        let hei = h - 50
        
        //0
        let button0 = UIButton(type: UIButton.ButtonType.system)
        button0.tag = 0
        button0.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        button0.addTarget(self, action: #selector(numButton(_:)), for: UIControl.Event.touchUpInside)
        button0.setTitle("0", for: UIControl.State.normal)
        button0.setTitleColor(UIColor.black, for: UIControl.State.normal)
        button0.backgroundColor = UIColor.init(red: 0.8, green: 1, blue: 0.8, alpha: 1)
        button0.layer.cornerRadius = 30
        button0.frame = CGRect(x: 0, y: 0, width: bw, height: bw)
        button0.center = CGPoint(x: wid*3, y: hei - h/16)
        self.view.addSubview(button0)
        
        //1
        let button1 = UIButton(type: UIButton.ButtonType.system)
        button1.tag = 1
        button1.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        button1.addTarget(self, action: #selector(numButton(_:)), for: UIControl.Event.touchUpInside)
        button1.setTitle("1", for: UIControl.State.normal)
        button1.setTitleColor(UIColor.black, for: UIControl.State.normal)
        button1.backgroundColor = UIColor.init(red: 0.8, green: 1, blue: 0.8, alpha: 1)
        button1.layer.cornerRadius = 30
        button1.frame = CGRect(x: 0, y: 0, width: bw, height: bw)
        button1.center = CGPoint(x: wid, y: hei - h*3/16)
        self.view.addSubview(button1)
        
        //2
        let button2 = UIButton(type: UIButton.ButtonType.system)
        button2.tag = 2
        button2.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        button2.addTarget(self, action: #selector(numButton(_:)), for: UIControl.Event.touchUpInside)
        button2.setTitle("2", for: UIControl.State.normal)
        button2.setTitleColor(UIColor.black, for: UIControl.State.normal)
        button2.backgroundColor = UIColor.init(red: 0.8, green: 1, blue: 0.8, alpha: 1)
        button2.layer.cornerRadius = 30
        button2.frame = CGRect(x: 0, y: 0, width: bw, height: bw)
        button2.center = CGPoint(x: wid*3, y: hei - h*3/16)
        self.view.addSubview(button2)
        
        //3
        let button3 = UIButton(type: UIButton.ButtonType.system)
        button3.tag = 3
        button3.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        button3.addTarget(self, action: #selector(numButton(_:)), for: UIControl.Event.touchUpInside)
        button3.setTitle("3", for: UIControl.State.normal)
        button3.setTitleColor(UIColor.black, for: UIControl.State.normal)
        button3.backgroundColor = UIColor.init(red: 0.8, green: 1, blue: 0.8, alpha: 1)
        button3.layer.cornerRadius = 30
        button3.frame = CGRect(x: 0, y: 0, width: bw, height: bw)
        button3.center = CGPoint(x: wid*5, y: hei - h*3/16)
        self.view.addSubview(button3)
        
        //4
        let button4 = UIButton(type: UIButton.ButtonType.system)
        button4.tag = 4
        button4.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        button4.addTarget(self, action: #selector(numButton(_:)), for: UIControl.Event.touchUpInside)
        button4.setTitle("4", for: UIControl.State.normal)
        button4.setTitleColor(UIColor.black, for: UIControl.State.normal)
        button4.backgroundColor = UIColor.init(red: 0.8, green: 1, blue: 0.8, alpha: 1)
        button4.layer.cornerRadius = 30
        button4.frame = CGRect(x: 0, y: 0, width: bw, height: bw)
        button4.center = CGPoint(x: wid, y: hei - h*5/16)
        self.view.addSubview(button4)
        
        //5
        let button5 = UIButton(type: UIButton.ButtonType.system)
        button5.tag = 5
        button5.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        button5.addTarget(self, action: #selector(numButton(_:)), for: UIControl.Event.touchUpInside)
        button5.setTitle("5", for: UIControl.State.normal)
        button5.setTitleColor(UIColor.black, for: UIControl.State.normal)
        button5.backgroundColor = UIColor.init(red: 0.8, green: 1, blue: 0.8, alpha: 1)
        button5.layer.cornerRadius = 30
        button5.frame = CGRect(x: 0, y: 0, width: bw, height: bw)
        button5.center = CGPoint(x: wid*3, y: hei - h*5/16)
        self.view.addSubview(button5)
        
        //6
        let button6 = UIButton(type: UIButton.ButtonType.system)
        button6.tag = 6
        button6.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        button6.addTarget(self, action: #selector(numButton(_:)), for: UIControl.Event.touchUpInside)
        button6.setTitle("6", for: UIControl.State.normal)
        button6.setTitleColor(UIColor.black, for: UIControl.State.normal)
        button6.backgroundColor = UIColor.init(red: 0.8, green: 1, blue: 0.8, alpha: 1)
        button6.layer.cornerRadius = 30
        button6.frame = CGRect(x: 0, y: 0, width: bw, height: bw)
        button6.center = CGPoint(x: wid*5, y: hei - h*5/16)
        self.view.addSubview(button6)
        
        //7
        let button7 = UIButton(type: UIButton.ButtonType.system)
        button7.tag = 7
        button7.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        button7.addTarget(self, action: #selector(numButton(_:)), for: UIControl.Event.touchUpInside)
        button7.setTitle("7", for: UIControl.State.normal)
        button7.setTitleColor(UIColor.black, for: UIControl.State.normal)
        button7.backgroundColor = UIColor.init(red: 0.8, green: 1, blue: 0.8, alpha: 1)
        button7.layer.cornerRadius = 30
        button7.frame = CGRect(x: 0, y: 0, width: bw, height: bw)
        button7.center = CGPoint(x: wid, y: hei - h*7/16)
        self.view.addSubview(button7)
        
        //8
        let button8 = UIButton(type: UIButton.ButtonType.system)
        button8.tag = 8
        button8.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        button8.addTarget(self, action: #selector(numButton(_:)), for: UIControl.Event.touchUpInside)
        button8.setTitle("8", for: UIControl.State.normal)
        button8.setTitleColor(UIColor.black, for: UIControl.State.normal)
        button8.backgroundColor = UIColor.init(red: 0.8, green: 1, blue: 0.8, alpha: 1)
        button8.layer.cornerRadius = 30
        button8.frame = CGRect(x: 0, y: 0, width: bw, height: bw)
        button8.center = CGPoint(x: wid*3, y: hei - h*7/16)
        self.view.addSubview(button8)
        
        //9
        let button9 = UIButton(type: UIButton.ButtonType.system)
        button9.tag = 9
        button9.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        button9.addTarget(self, action: #selector(numButton(_:)), for: UIControl.Event.touchUpInside)
        button9.setTitle("9", for: UIControl.State.normal)
        button9.setTitleColor(UIColor.black, for: UIControl.State.normal)
        button9.backgroundColor = UIColor.init(red: 0.8, green: 1, blue: 0.8, alpha: 1)
        button9.layer.cornerRadius = 30
        button9.frame = CGRect(x: 0, y: 0, width: bw, height: bw)
        button9.center = CGPoint(x: wid*5, y: hei - h*7/16)
        self.view.addSubview(button9)
    }
    
    //Not Number Buttons
    func setElementOption(w: CGFloat, h: CGFloat) {
        //button size
        let bw = w / 4 - 20
        let wid = w / 8
        let hei = h - 50
        
        //Go to SC
        let buttonSC = UIButton(type: UIButton.ButtonType.system)
        buttonSC.tag = 10
        buttonSC.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        buttonSC.addTarget(self, action: #selector(otherButton(_:)), for: UIControl.Event.touchUpInside)
        buttonSC.setTitle("←SC", for: UIControl.State.normal)
        buttonSC.setTitleColor(UIColor.black, for: UIControl.State.normal)
        buttonSC.backgroundColor = UIColor.init(red: 0.8, green: 1, blue: 0.8, alpha: 1)
        buttonSC.layer.cornerRadius = 30
        buttonSC.frame = CGRect(x: 0, y: 0, width: bw, height: bw)
        buttonSC.center = CGPoint(x: wid, y: hei - h/16)
        self.view.addSubview(buttonSC)
        
        //Point
        let buttonPoint = UIButton(type: UIButton.ButtonType.system)
        buttonPoint.tag = 11
        buttonPoint.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        buttonPoint.addTarget(self, action: #selector(otherButton(_:)), for: UIControl.Event.touchUpInside)
        buttonPoint.setTitle(".", for: UIControl.State.normal)
        buttonPoint.setTitleColor(UIColor.black, for: UIControl.State.normal)
        buttonPoint.backgroundColor = UIColor.init(red: 0.8, green: 1, blue: 0.8, alpha: 1)
        buttonPoint.layer.cornerRadius = 30
        buttonPoint.frame = CGRect(x: 0, y: 0, width: bw, height: bw)
        buttonPoint.center = CGPoint(x: wid*5, y: hei - h/16)
        self.view.addSubview(buttonPoint)
        
        //=
        let buttonEqu = UIButton(type: UIButton.ButtonType.system)
        buttonEqu.tag = 12
        buttonEqu.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        buttonEqu.addTarget(self, action: #selector(otherButton(_:)), for: UIControl.Event.touchUpInside)
        buttonEqu.setTitle("=", for: UIControl.State.normal)
        buttonEqu.setTitleColor(UIColor.black, for: UIControl.State.normal)
        buttonEqu.backgroundColor = UIColor.init(red: 0.8, green: 1, blue: 0.8, alpha: 1)
        buttonEqu.layer.cornerRadius = 30
        buttonEqu.frame = CGRect(x: 0, y: 0, width: bw, height: bw)
        buttonEqu.center = CGPoint(x: wid*7, y: hei - h/16)
        self.view.addSubview(buttonEqu)
        
        //+
        let buttonAdd = UIButton(type: UIButton.ButtonType.system)
        buttonAdd.tag = 13
        buttonAdd.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        buttonAdd.addTarget(self, action: #selector(otherButton(_:)), for: UIControl.Event.touchUpInside)
        buttonAdd.setTitle("+", for: UIControl.State.normal)
        buttonAdd.setTitleColor(UIColor.black, for: UIControl.State.normal)
        buttonAdd.backgroundColor = UIColor.init(red: 0.8, green: 1, blue: 0.8, alpha: 1)
        buttonAdd.layer.cornerRadius = 30
        buttonAdd.frame = CGRect(x: 0, y: 0, width: bw, height: bw)
        buttonAdd.center = CGPoint(x: wid*7, y: hei - h*3/16)
        self.view.addSubview(buttonAdd)
        
        //-
        let buttonSub = UIButton(type: UIButton.ButtonType.system)
        buttonSub.tag = 14
        buttonSub.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        buttonSub.addTarget(self, action: #selector(otherButton(_:)), for: UIControl.Event.touchUpInside)
        buttonSub.setTitle("-", for: UIControl.State.normal)
        buttonSub.setTitleColor(UIColor.black, for: UIControl.State.normal)
        buttonSub.backgroundColor = UIColor.init(red: 0.8, green: 1, blue: 0.8, alpha: 1)
        buttonSub.layer.cornerRadius = 30
        buttonSub.frame = CGRect(x: 0, y: 0, width: bw, height: bw)
        buttonSub.center = CGPoint(x: wid*7, y: hei - h*5/16)
        self.view.addSubview(buttonSub)
        
        //×
        let buttonMul = UIButton(type: UIButton.ButtonType.system)
        buttonMul.tag = 15
        buttonMul.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        buttonMul.addTarget(self, action: #selector(otherButton(_:)), for: UIControl.Event.touchUpInside)
        buttonMul.setTitle("×", for: UIControl.State.normal)
        buttonMul.setTitleColor(UIColor.black, for: UIControl.State.normal)
        buttonMul.backgroundColor = UIColor.init(red: 0.8, green: 1, blue: 0.8, alpha: 1)
        buttonMul.layer.cornerRadius = 30
        buttonMul.frame = CGRect(x: 0, y: 0, width: bw, height: bw)
        buttonMul.center = CGPoint(x: wid*7, y: hei - h*7/16)
        self.view.addSubview(buttonMul)
        
        //AC
        let buttonAc = UIButton(type: UIButton.ButtonType.system)
        buttonAc.tag = 16
        buttonAc.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        buttonAc.addTarget(self, action: #selector(otherButton(_:)), for: UIControl.Event.touchUpInside)
        buttonAc.setTitle("AC", for: UIControl.State.normal)
        buttonAc.setTitleColor(UIColor.black, for: UIControl.State.normal)
        buttonAc.backgroundColor = UIColor.init(red: 0.8, green: 1, blue: 0.8, alpha: 1)
        buttonAc.layer.cornerRadius = 30
        buttonAc.frame = CGRect(x: 0, y: 0, width: bw, height: bw)
        buttonAc.center = CGPoint(x: wid, y: hei - h*9/16)
        self.view.addSubview(buttonAc)
        
        //±
        let buttonAS = UIButton(type: UIButton.ButtonType.system)
        buttonAS.tag = 17
        buttonAS.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        buttonAS.addTarget(self, action: #selector(otherButton(_:)), for: UIControl.Event.touchUpInside)
        buttonAS.setTitle("+/-", for: UIControl.State.normal)
        buttonAS.setTitleColor(UIColor.black, for: UIControl.State.normal)
        buttonAS.backgroundColor = UIColor.init(red: 0.8, green: 1, blue: 0.8, alpha: 1)
        buttonAS.layer.cornerRadius = 30
        buttonAS.frame = CGRect(x: 0, y: 0, width: bw, height: bw)
        buttonAS.center = CGPoint(x: wid*3, y: hei - h*9/16)
        self.view.addSubview(buttonAS)
        
        //%
        let buttonRem = UIButton(type: UIButton.ButtonType.system)
        buttonRem.tag = 18
        buttonRem.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        buttonRem.addTarget(self, action: #selector(otherButton(_:)), for: UIControl.Event.touchUpInside)
        buttonRem.setTitle("%", for: UIControl.State.normal)
        buttonRem.setTitleColor(UIColor.black, for: UIControl.State.normal)
        buttonRem.backgroundColor = UIColor.init(red: 0.8, green: 1, blue: 0.8, alpha: 1)
        buttonRem.layer.cornerRadius = 30
        buttonRem.frame = CGRect(x: 0, y: 0, width: bw, height: bw)
        buttonRem.center = CGPoint(x: wid*5, y: hei - h*9/16)
        self.view.addSubview(buttonRem)
        
        //÷
        let buttonDiv = UIButton(type: UIButton.ButtonType.system)
        buttonDiv.tag = 19
        buttonDiv.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        buttonDiv.addTarget(self, action: #selector(otherButton(_:)), for: UIControl.Event.touchUpInside)
        buttonDiv.setTitle("÷", for: UIControl.State.normal)
        buttonDiv.setTitleColor(UIColor.black, for: UIControl.State.normal)
        buttonDiv.backgroundColor = UIColor.init(red: 0.8, green: 1, blue: 0.8, alpha: 1)
        buttonDiv.layer.cornerRadius = 30
        buttonDiv.frame = CGRect(x: 0, y: 0, width: bw, height: bw)
        buttonDiv.center = CGPoint(x: wid*7, y: hei - h*9/16)
        self.view.addSubview(buttonDiv)
    }
    
    /*
    func setLandscape() {
        //
    }
    
    func setPortrate() {
        //
    }
 */
}

