//
//  SubmissionListWidget.swift
//  SubmissionListWidget
//
//  Created by 近松和矢 on 2021/12/24.
//

import WidgetKit
import SwiftUI
import Intents

@available(iOSApplicationExtension 14.0, *)
struct Provider: IntentTimelineProvider {
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), text: "asdf", configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), text: "asdf", configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for dateOffset in 0 ..< 3 {
            let entryDate = Calendar.current.date(byAdding: .day, value: dateOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, text: "asdf", configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let text: String
    let configuration: ConfigurationIntent
}

@available(iOSApplicationExtension 14.0, *)
struct SubmissionListWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
//        Text(entry.date, style: .time)
        Text(entry.text)
    }
}

@available(iOSApplicationExtension 14.0, *)
@main
struct SubmissionListWidget: Widget {
    let kind: String = "SubmissionListWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            SubmissionListWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("提出物リスト")
        .description("提出物の確認・新規作成を素早く行えます。")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

@available(iOSApplicationExtension 14.0, *)
struct SubmissionListWidget_Previews: PreviewProvider {
    static var previews: some View {
        SubmissionListWidgetEntryView(entry: SimpleEntry(date: Date(), text: "asdf", configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

struct SubmissionData {
    
}
