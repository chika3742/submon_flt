//
//  SubmissionListWidget.swift
//  WidgetsExtension
//
//  Created by 近松和矢 on 2021/12/24.
//

import WidgetKit
import SwiftUI
import Intents
import FirebaseAuth
import FirebaseFirestore

@available(iOS 15.0, *)
struct Provider: TimelineProvider {
    let schemaVer = 7
    
    func placeholder(in context: Context) -> SubmissionEntry {
        SubmissionEntry.preview()
    }

    func getSnapshot(in context: Context, completion: @escaping (SubmissionEntry) -> ()) {
        let entry = SubmissionEntry.preview()
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SubmissionEntry] = []
        
        do {
            try Auth.auth().useUserAccessGroup("B66Z929S96.net.chikach.submon")
        } catch let error as NSError {
            print(error)
        }
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                let db = Firestore.firestore()
                
                db.document("users/\(user!.uid)").getDocument { docSnapshot, error in
                    if (error == nil && docSnapshot!.data()?["schemaVersion"] as! Int64 == schemaVer) {
                        db.collection("users/\(user!.uid)/submission").whereField("done", isEqualTo: false).getDocuments { snapshot, error  in
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
                        print("An error occured while generating widget timeline.")
                        print(error ?? "")
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
    let schemaVersionMismatch: Bool
    let submissions: [SubmissionData]
    
    static func preview() -> Self {
        SubmissionEntry(date: Date(), isPreview: true, isSignedIn: true, schemaVersionMismatch: false, submissions: [])
    }
    
    static func notSignedIn() -> Self {
        SubmissionEntry(date: Date(), isPreview: false, isSignedIn: false, schemaVersionMismatch: false,submissions: [])
    }
    
    static func schemaVersionMismatch() -> Self {
        SubmissionEntry(date: Date(), isPreview: false, isSignedIn: true, schemaVersionMismatch: true, submissions: [])
    }
    
    static func entry(date: Date, submissions: [SubmissionData]) -> Self {
        SubmissionEntry(date: date, isPreview: false, isSignedIn: true, schemaVersionMismatch: false, submissions: submissions)
    }
//    let configuration: ConfigurationIntent
}

@available(iOS 15.0, *)
struct SubmissionListWidgetEntryView : View {
    @Environment(\.widgetFamily) var family
//    var family: WidgetFamily = .systemLarge
    var entry: Provider.Entry
    
    @ViewBuilder
    var body: some View {
        if !entry.isSignedIn {
            buildNotSignedIn()
        } else {
            if entry.isPreview {
                buildPreview()
            } else {
                if entry.schemaVersionMismatch {
                    buildSchemaVersionMismatch()
                } else {
                    let listEntries = self.entry.submissions
                    
                    let sliceCount = (family != .systemLarge ? 4 : 10)
                    if listEntries.count >= sliceCount {
                        buildItemView(items: Array(listEntries[0..<sliceCount]))
                    } else {
                        buildItemView(items: listEntries)
                    }
                }
            }
        }
    }
    
    func buildNotSignedIn() -> some View {
        Text("ウィジェットを利用するにはログインする必要があります")
            .font(.caption)
            .padding()
    }
    
    func buildSchemaVersionMismatch() -> some View {
        Text("Submonを最新版にアップデートしてください")
            .font(.caption)
            .padding()
    }
    
    func buildPreview() -> some View {
        var listEntries = [SubmissionData]()
        
        let currentDate = Date()
        
        for n in 0..<4 {
            let entryDate = Calendar.current.date(byAdding: .day, value: n, to: currentDate)!
            listEntries.append(SubmissionData(id: 0, title: "提出物\(n + 1)", due: entryDate))
        }
        
        return buildItemView(items: listEntries)
    }
    
    func buildItemView(items: [SubmissionData]) -> some View {
        return HStack(alignment: .bottom) {
            VStack(alignment: .leading) {
                Text("提出物リスト").font(.headline)
                Spacer()
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading) {
                        ForEach(0..<items.count, id: \.self) { index in
                            let item = items[index]
                            let delta = Int(item.due - entry.date) / (60 * 60)
                            VStack {
                                HStack {
                                    if family != .systemSmall {
                                        Text({
                                            let absDelta = abs(delta)
                                            if (absDelta < 24) {
                                                return "\(delta) 時間"
                                            } else if (absDelta < 24 * 7) {
                                                return "\(delta / 24) 日"
                                            } else if (absDelta < 24 * 30) {
                                                return "\(delta / (24 * 7)) 週間"
                                            } else {
                                                return "\(delta / (24 * 30)) ヶ月"
                                            }
                                        }() as String)
                                            .font(.subheadline)
                                            .foregroundColor({
                                                if (delta < 0) {
                                                    return .red
                                                }
                                                if (delta <= 48) {
                                                    return .orange
                                                }
                                                return .green
                                            }())
                                    }
                                    Text(item.title)
                                        .font(.subheadline)
                                }.padding(.bottom, -1)
                            }
                        }
                        Spacer()
                    }
                    Spacer()
                    if (family != .systemSmall) {
                        Link(destination: URL(string: "submon:///create-submission")!) {
                        Image("add-add_symbol")
                            .frame(width: 50, height: 50, alignment: .center)
                            .tint(.white)
                            .background(.green)
                            .clipShape(Circle())
                        }
                    }
                }
                
            }
        }.padding()
    }
}

@available(iOS 15.0, *)
struct SubmissionListWidget: Widget {
    let kind: String = "SubmissionListWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            SubmissionListWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("提出物リスト")
        .description("提出物の確認・新規作成を素早く行えます。")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

@available(iOS 15.0, *)
struct SubmissionListWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SubmissionListWidgetEntryView(entry: SubmissionEntry.preview())
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            SubmissionListWidgetEntryView(entry: SubmissionEntry.preview())
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            SubmissionListWidgetEntryView(entry: SubmissionEntry.preview())
                .previewContext(WidgetPreviewContext(family: .systemExtraLarge))
        }
    }
}

struct SubmissionData: Decodable {
    let id: Int64
    let title: String
    let due: Date
    
    static func fromDic(dic: [String: Any]) -> Self? {
        do {
            let json = try JSONSerialization.data(withJSONObject: dic)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted({
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                return formatter
            }())
            let decoded = try decoder.decode(Self.self, from: json)
            return decoded
        } catch let e {
            print(e)
            return nil
        }
    }
}
