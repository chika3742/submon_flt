//
//  SubmissionListWidget.swift
//  SubmissionListWidget
//
//  Created by 近松和矢 on 2021/12/24.
//

import WidgetKit
import SwiftUI
import Intents
import Firebase

@available(iOS 14.0, *)
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SubmissionEntry {
        SubmissionEntry.preview()
    }

    func getSnapshot(in context: Context, completion: @escaping (SubmissionEntry) -> ()) {
        let entry = SubmissionEntry.preview()
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SubmissionEntry] = []
        
        if FirebaseApp.allApps?.isEmpty == true {
            FirebaseApp.configure()
        }
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                let db = Firestore.firestore()
                db.collection("users/\(user!.uid)/submission").getDocuments { snapshot, error  in
                    if error == nil {
                        let docs = snapshot!.documents
                        let submissions = docs.map { e in
                            SubmissionData.fromDic(dic: e.data())!
                        }
                        
                        let currentDate = Date()
                        for dateOffset in 0 ..< 3 {
                            let entryDate = Calendar.current.date(byAdding: .day, value: dateOffset, to: currentDate)!
                            let entry = SubmissionEntry.entry(date: entryDate, submissions: submissions)
                            entries.append(entry)
                        }
                        
                        let timeline = Timeline(entries: entries, policy: .atEnd)
                        
                        completion(timeline)
                    } else {
                        print("An error occured while generating widget timeline.")
                        print(error!)
                    }
                }
            } else {
                entries.append(SubmissionEntry.notSignedIn())
                
                let timeline = Timeline(entries: entries, policy: .atEnd)
                
                completion(timeline)
            }
        }

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        
    }
}

struct SubmissionEntry: TimelineEntry {
    let date: Date
    let isPreview: Bool
    let isSignedIn: Bool
    let submissions: [SubmissionData]
    
    static func preview() -> Self {
        SubmissionEntry(date: Date(), isPreview: true, isSignedIn: false, submissions: [])
    }
    
    static func notSignedIn() -> Self {
        SubmissionEntry(date: Date(), isPreview: false, isSignedIn: false, submissions: [])
    }
    
    static func entry(date: Date, submissions: [SubmissionData]) -> Self {
        SubmissionEntry(date: date, isPreview: false, isSignedIn: true, submissions: submissions)
    }
//    let configuration: ConfigurationIntent
}

@available(iOS 14.0, *)
struct SubmissionListWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        if entry.isPreview {
            return Text("asdf")
        }
        if !entry.isSignedIn {
            return Text("iOSでウィジェットを利用するには、ログインする必要があります")
        } else {
            var listEntries = self.entry.submissions
            
            if entry.isPreview {
                let currentDate = Date()
                let formatter = DateFormatter()
                formatter.dateStyle = .short
                formatter.timeStyle = .short
                for n in 0..<3 {
                    let entryDate = Calendar.current.date(byAdding: .day, value: n, to: currentDate)!
                    listEntries.append(SubmissionData(id: 0, title: "提出物1", date: formatter.string(from: entryDate)))
                }
            }
            return Text(entry.date, style: .time)
        }
    }
}

@available(iOS 14.0, *)
@main
struct SubmissionListWidget: Widget {
    let kind: String = "SubmissionListWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            SubmissionListWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("提出物リスト")
        .description("提出物の確認・新規作成を素早く行えます。")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

@available(iOS 14.0, *)
struct SubmissionListWidget_Previews: PreviewProvider {
    static var previews: some View {
        SubmissionListWidgetEntryView(entry: SubmissionEntry.preview())
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

struct SubmissionData: Decodable {
    let id: Int64
    let title: String
    let date: String
    
    static func fromDic(dic: [String: Any]) -> Self? {
        do {
            let json = try JSONSerialization.data(withJSONObject: dic)
            let decoder = JSONDecoder()
            let decoded = try decoder.decode(Self.self, from: json)
            return decoded
        } catch let e {
            print(e)
            return nil
        }
    }
}
