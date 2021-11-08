//
//  CalculateViewController.swift
//  SC
//
//  Created by Narumi Nogawa on 2020/04/27.
//  Copyright © 2020 Narumi Nogawa. All rights reserved.
//

import AppTrackingTransparency
import UIKit

import GoogleMobileAds

// MARK: 電卓画面のVC
class CalculateViewController: UIViewController {
    
    @IBOutlet private weak var topAdView: GADBannerView!
    @IBOutlet private weak var bottomAdView: GADBannerView!
    @IBOutlet private weak var memoryLabel: UILabel!
    @IBOutlet private weak var resultLabel: UILabel!
    
    private var numOnScreen: Float = 0
    private var preNum: Float = 0
    
    private var canCalculate: Bool = false
    private var operationNum: Int = 0
    
    private var memoryNumOnScreen: Float = 0
    
    private let greenButtonColor = UIColor(red: 0.8, green: 1.0, blue: 0.8, alpha: 1.0)
    private let url = NSURL(string: PSCStringStorage.init().BLOG_URL)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setAdvertisement()
        
        self.memoryNumOnScreen = UserDefaults.standard.float(forKey: "memory_num_on_screen")
        self.memoryLabel.text = self.memoryNumOnScreen.description
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadBannerAd()
        self.requestIDFA()
    }
    
    override func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.loadBannerAd()
        })
    }
    
    private func requestIDFA() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { _ in })
        }
    }
    
    // Green Buttons: tag = (0~9)
    @IBAction private func numberButtonTapped(_ sender: UIButton) {
        if self.canCalculate == true || self.resultLabel.text == "0" {
            self.resultLabel.text = sender.tag.description
            self.numOnScreen = NSString(string: self.resultLabel.text!).floatValue
            self.canCalculate = false
        } else {
            self.resultLabel.text = self.resultLabel.text! + sender.tag.description
            self.numOnScreen = NSString(string: self.resultLabel.text!).floatValue
        }
    }
    
    // Dark Gray Buttons: tag = (10~14)
    // C, ., AC, +-, %
    @IBAction private func darkGrayOperationButtonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 10: // C
            if self.resultLabel.text!.count > 1 {
                _ = self.resultLabel.text!.popLast()
                self.numOnScreen = NSString(string: self.resultLabel.text!).floatValue
            } else {
                self.resultLabel.text = "0"
                self.numOnScreen = 0
            }
        case 11: // .
            if self.getLastChar() != "." {
                self.resultLabel.text?.append(".")
            } else {
                _ = self.resultLabel.text?.popLast()
            }
        case 12: // AC
            self.resultLabel.text = "0"
            self.preNum = 0
            self.numOnScreen = 0
            self.operationNum = 0
        case 13: // +/-
            self.preNum = NSString(string: self.resultLabel.text!).floatValue
            var tmp = NSString(string: self.resultLabel.text!).floatValue
            tmp *= -1.0
            self.numOnScreen = tmp
            self.resultLabel.text = tmp.description
        case 14: // %
            self.calculateOperation() // 最後がoperationじゃないかの確認
            if self.getLastChar() >= "0" && self.getLastChar() <= "9" {
            } else {
                _ = self.resultLabel.text?.popLast()
            }
            self.preNum = NSString(string: self.resultLabel.text!).floatValue
            self.resultLabel.text?.append("%")
            self.operationNum = sender.tag
            self.canCalculate = true
        default:
            print("may not be come in here...")
        }
    }
    
    // Yellow Buttons: tag = (15~19)
    // =, +, -, *, /
    @IBAction private func yellowOperationButtonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 15: // =
            self.calculateOperation()
        case 16: // +
            self.calculateOperation() // 最後がoperationじゃないかの確認
            if self.getLastChar() >= "0" && self.getLastChar() <= "9" {
            } else {
                _ = self.resultLabel.text?.popLast()
            }
            self.preNum = NSString(string: self.resultLabel.text!).floatValue
            self.resultLabel.text?.append("+")
            self.operationNum = sender.tag
            self.canCalculate = true
        case 17: // -
            self.calculateOperation() // 最後がoperationじゃないかの確認
            if self.getLastChar() >= "0" && self.getLastChar() <= "9" {
            } else {
                _ = self.resultLabel.text?.popLast()
            }
            self.preNum = NSString(string: self.resultLabel.text!).floatValue
            self.resultLabel.text?.append("-")
            self.operationNum = sender.tag
            self.canCalculate = true
        case 18: // ×
            self.calculateOperation() // 最後がoperationじゃないかの確認
            if self.getLastChar() >= "0" && self.getLastChar() <= "9" {
            } else {
                _ = self.resultLabel.text?.popLast()
            }
            self.preNum = NSString(string: self.resultLabel.text!).floatValue
            self.resultLabel.text?.append("×")
            self.operationNum = sender.tag
            self.canCalculate = true
        case 19: // ÷
            self.calculateOperation() // 最後がoperationじゃないかの確認
            if self.getLastChar() >= "0" && self.getLastChar() <= "9" {
            } else {
                _ = self.resultLabel.text?.popLast()
            }
            self.preNum = NSString(string: self.resultLabel.text!).floatValue
            self.resultLabel.text?.append("÷")
            self.operationNum = sender.tag
            self.canCalculate = true
        default:
            print("may not be come in here...")
        }
    }
    
    // Light Gray Buttons: tag = (20~29)
    // √, !, 1/x, ^x, 10^x, MC, M+, M-, MR, ?
    @IBAction private func lightGrayOperationButtonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 20: // √
            // TODO: perationじゃないかの確認 する？
            if self.getLastChar() >= "0" && self.getLastChar() <= "9" {
                self.preNum = NSString(string: self.resultLabel.text!).floatValue
                self.resultLabel.text = sqrtf(self.numOnScreen).description
                self.numOnScreen = NSString(string: self.resultLabel.text!).floatValue
            } else {
                _ = self.resultLabel.text?.popLast()
            }
        case 21: // !
            // TODO: perationじゃないかの確認 する？
            if self.resultLabel.text == "0" || self.resultLabel.text == "0.0" {
            } else {
                self.preNum = NSString(string: self.resultLabel.text!).floatValue
                let roop = Int(self.numOnScreen)
                var ans = 1
                for i in 0..<roop {
                    ans *= i + 1
                }
                self.resultLabel.text = ans.description
                self.numOnScreen = NSString(string: self.resultLabel.text!).floatValue
            }
        case 22: // 1/x
            // TODO: perationじゃないかの確認 する？
            if self.resultLabel.text == "0" || self.resultLabel.text == "0.0" {
            } else {
                self.preNum = NSString(string: self.resultLabel.text!).floatValue
                self.resultLabel.text = (1 / self.numOnScreen).description
                self.numOnScreen = NSString(string: self.resultLabel.text!).floatValue
            }
        case 23: // ^x
            self.calculateOperation() // 最後がoperationじゃないかの確認
            if self.getLastChar() >= "0" && self.getLastChar() <= "9" {
            } else {
                _ = self.resultLabel.text?.popLast()
            }
            self.preNum = NSString(string: self.resultLabel.text!).floatValue
            self.resultLabel.text?.append("^")
            self.operationNum = sender.tag
            self.canCalculate = true
        case 24: // 10^x
            // TODO: perationじゃないかの確認 する？
            if self.resultLabel.text == "0" || self.resultLabel.text == "0.0" {
            } else {
                self.preNum = NSString(string: self.resultLabel.text!).floatValue
                self.resultLabel.text = powf(10, self.numOnScreen).description
                self.numOnScreen = NSString(string: self.resultLabel.text!).floatValue
            }
        case 25: // mc
            self.memoryNumOnScreen = 0
            self.memoryLabel.text = self.memoryNumOnScreen.description
            UserDefaults.standard.set(self.memoryNumOnScreen, forKey: "memory_num_on_screen")
        case 26: // m+
            self.memoryNumOnScreen += self.numOnScreen
            self.memoryLabel.text = self.memoryNumOnScreen.description
            UserDefaults.standard.set(self.memoryNumOnScreen, forKey: "memory_num_on_screen")
        case 27: // m-
            self.memoryNumOnScreen -= self.numOnScreen
            self.memoryLabel.text = self.memoryNumOnScreen.description
            UserDefaults.standard.set(self.memoryNumOnScreen, forKey: "memory_num_on_screen")
        case 28: // mr
            self.numOnScreen = self.memoryNumOnScreen
            self.resultLabel.text = self.numOnScreen.description
            UserDefaults.standard.set(self.memoryNumOnScreen, forKey: "memory_num_on_screen")
        case 29: // ?
            if UIApplication.shared.canOpenURL(self.url! as URL) {
                UIApplication.shared.open(self.url! as URL, options: [:], completionHandler: nil)
            }
        default:
            print("may not be come in here...")
        }
    }
    
    private func calculateOperation() {
        switch self.operationNum {
        case 14: // %
            self.resultLabel.text = self.preNum.truncatingRemainder(dividingBy: self.numOnScreen).description
            self.numOnScreen = self.preNum.truncatingRemainder(dividingBy: self.numOnScreen)
        case 16: // +
            self.resultLabel.text = (self.preNum + self.numOnScreen).description
            self.numOnScreen += self.preNum
        case 17: // -
            self.resultLabel.text = (self.preNum - self.numOnScreen).description
            self.numOnScreen -= self.preNum
        case 18: // *
            self.resultLabel.text = (self.preNum * self.numOnScreen).description
            self.numOnScreen *= self.preNum
        case 19: // /
            self.resultLabel.text = (self.preNum / self.numOnScreen).description
            self.numOnScreen /= self.preNum
        case 23: // ^x
            self.resultLabel.text = powf(self.preNum, self.numOnScreen).description
            self.numOnScreen = powf(self.preNum, self.numOnScreen)
        default:
            print("may not be come in here.")
        }
        
        self.operationNum = 0
    }
    
    private func getLastChar() -> Character {
        return resultLabel.text?.last ?? "0"
    }
    
}

// MARK: バナー広告の設定を行う拡張
extension CalculateViewController: GADBannerViewDelegate {
    
    private func loadBannerAd() {
        let frame = { () -> CGRect in
            return view.frame.inset(by: view.safeAreaInsets)
        }()
        let viewWidth = frame.size.width
        self.topAdView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
        self.topAdView.load(GADRequest())
        self.bottomAdView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
        self.bottomAdView.load(GADRequest())
    }
    
    private func setAdvertisement() {
        self.topAdView.adUnitID = PSCStringStorage.init().TOP_AD_UNIT_ID
        self.topAdView.rootViewController = self
        self.bottomAdView.adUnitID = PSCStringStorage.init().BOTTOM_AD_UNIT_ID
        self.bottomAdView.rootViewController = self
    }
    
}
