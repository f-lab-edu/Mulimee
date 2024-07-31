//
//  MulimeeWidget.swift
//  MulimeeWidget
//
//  Created by Kyeongmo Yang on 7/19/24.
//

import SwiftUI
import WidgetKit

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> MulimeeEntry {
        MulimeeEntry(date: .now,
                     numberOfGlasses: 0,
                     configuration: ConfigurationAppIntent())
    }
    
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> MulimeeEntry {
        return MulimeeEntry(date: .now,
                            numberOfGlasses: 0,
                            configuration: ConfigurationAppIntent())
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<MulimeeEntry> {
        var entries: [MulimeeEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = MulimeeEntry(date: entryDate,
                                numberOfGlasses: 0,
                                configuration: ConfigurationAppIntent())
            entries.append(entry)
        }
        
        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct MulimeeEntry: TimelineEntry {
    let date: Date
    let numberOfGlasses: Int
    let configuration: ConfigurationAppIntent
}

struct MulimeeWidgetEntryView : View {
    var entry: Provider.Entry
    private var numberOfGlasses: Int {
        entry.numberOfGlasses
    }
    
    var body: some View {
        ZStack {
            Image("\(numberOfGlasses)")
                .resizable()
            
            VStack {
                Spacer()
                
                HStack {
                    Button(intent: MulimeeIntent()) {
                        Text("마시기")
                            .font(.caption2)
                            .foregroundColor(.white)
                    }
                    .background(Color.teal)
                    .cornerRadius(10)
                    
                    Spacer()
                    
                    Text("\(numberOfGlasses)잔")
                        .font(.title)
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 3)
                }
            }
        }
    }
}

struct MulimeeWidget: Widget {
    let kind: String = .widgetKind
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            MulimeeWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}


#Preview(as: .systemSmall) {
    MulimeeWidget()
} timeline: {
    MulimeeEntry(date: .now, numberOfGlasses: 0, configuration: .init())
    MulimeeEntry(date: .now, numberOfGlasses: 4, configuration: .init())
    MulimeeEntry(date: .now, numberOfGlasses: 8, configuration: .init())
}
