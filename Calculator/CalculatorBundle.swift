//
//  CalculatorBundle.swift
//  Calculator
//
//  Created by 野川成己 on 2023/01/03.
//  Copyright © 2023 Narumi Nogawa. All rights reserved.
//

import WidgetKit
import SwiftUI

@main
struct CalculatorBundle: WidgetBundle {
    var body: some Widget {
        Calculator()
        CalculatorLiveActivity()
    }
}
