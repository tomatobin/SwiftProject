//
//  MonitorWidget.swift
//  MonitorWidget
//
//  Created by iblue on 2020/11/27.
//  Copyright © 2020 iblue. All rights reserved.
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

        
        // 添加更新时间段
        let currentDate = Date()
        let refreshInterval: Int = 3 //刷新间隔
        for secondOffset in stride(from: 0, to: 3600 , by: refreshInterval) {
            let entryDate = Calendar.current.date(byAdding: .second, value: secondOffset, to: currentDate)!
            //let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }
    

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    func httpRequest(requestUrl: String) -> Void {
//        guard let url = URL(string: requestUrl) else {
//            return
//        }
//
//        let urlRequest = URLRequest(url: url)
//        let config = URLSessionConfiguration.default
//        //config.httpAdditionalHeaders = ["Content-Type":"application/json"]
//        config.timeoutIntervalForRequest = 5
//        config.requestCachePolicy = .reloadIgnoringLocalCacheData
//        let session = URLSession(configuration: config)
//
//        session.dataTask(with: urlRequest) { (data, _, _ ) in
//            if let resultData = data {
//                print("🍎🍎🍎 \(#function):: data")
////                let cfEncoding = CFStringEncodings.GB_18030_2000
////                let encoding = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEncoding.rawValue))
////
////                if let listString = String(data: resultData, encoding: String.Encoding(rawValue: encoding)) {
////
////                }
//            }
//        }.resume()
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct MonitorWidgetEntryView : View {
    var entry: Provider.Entry
    
    var content: String = "This is a simple widget"

    var body: some View {
        Text("\(content)_\(entry.date)")
    }
}

@main
struct MonitorWidget: Widget {
    let kind: String = "MonitorWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            MonitorWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct MonitorWidget_Previews: PreviewProvider {
    static var previews: some View {
        MonitorWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
