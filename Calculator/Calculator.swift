//
//  Calculator.swift
//  Calculator
//
//  Created by 野川成己 on 2023/01/03.
//  Copyright © 2023 Narumi Nogawa. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct CalculatorButtonStyle: ButtonStyle {
    
    var size: CGFloat
    var backgroundColor: Color
    var foregroundColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 15, weight: .medium))
            .frame(width: size, height: size)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .overlay {
                if configuration.isPressed {
                    Color(white: 1.0, opacity: 0.2)
                }
            }
            .clipShape(Capsule())
    }
}

struct CalculatorEntryView: View {
    var buttonTypes: [[ButtonType]] {
        [[
            .allClear,
            .operation(.addition),
            .operation(.subtraction),
            .operation(.multiplication),
            .operation(.division),
            .equals,
            .decimal
        ], [
            .digit(.zero),
            .digit(.one),
            .digit(.two),
            .digit(.three),
            .digit(.four),
            .digit(.five),
            .digit(.six),
            .digit(.seven),
            .digit(.eight),
            .digit(.nine)
        ]]
    }
    
    @State var text: String = "0"
    var body: some View {
        VStack {
            Spacer()
            Text(text)
                .padding()
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .font(.system(size: 60, weight: .light))
                .lineLimit(1)
                .minimumScaleFactor(0.2)
            VStack {
                ForEach(buttonTypes, id: \.self) { row in
                      HStack {
                          ForEach(row, id: \.self) { buttonType in
                              Button(buttonType.description) {
                                  // todo: add event
                                  print(buttonType.foregroundColor)
                              }
                                  .buttonStyle(CalculatorButtonStyle(
                                    size: UIScreen.main.bounds.width / 16,
                                    backgroundColor: buttonType.backgroundColor,
                                    foregroundColor: buttonType.foregroundColor
                                  ))
                          }
                      }
                }
            }
//                // 末尾が.なら削除
//                // .を中に含むなら何も処理しない
//                // 上記以外の場合、末尾に.を追加
//                self.text.append(".")
            Spacer()
        }
        .background(Color.black)
    }
}

struct Calculator: Widget {
    let kind: String = "Calculator"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            CalculatorEntryView()
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemMedium])
    }
}

struct Calculator_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorEntryView()
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
