//
//  EWWidgets.swift
//  EWWidgets
//
//  Created by Ilya on 29.10.20.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        
        SimpleEntry(date: Date(),
                    air: "+2",
                    water: "+12",
                    level: "140cm")
        
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry =
            //SimpleEntry(date: Date())
            SimpleEntry(date: Date(),
                        air: "+2",
                        water: "+12",
                        level: "140cm")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for offset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: 15 * offset, to: currentDate)!
            let entry =
                SimpleEntry(date: entryDate,
                            air: "+2",
                            water: "+12",
                            level: "140cm")
            
                //SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    
    internal init(date: Date, air: String, water: String, level: String) {
        self.date = date
        self.air = air
        self.water = water
        self.level = level
    }
    
    let date: Date
    let air: String
    let water: String
    let level: String
}

struct EWWidgetsEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        
        ZStack {
            Color.black.opacity(0.8)
            VStack(alignment: .leading) {
                Text("E2 Eisbachwelle")
                    .foregroundColor(.white)
                    .bold()
                    .font(.callout)
                
                ViewWithIcon(imageName: "water", value: entry.water, trend: true)
                ViewWithIcon(imageName: "air", value: entry.air, trend: false)
                ViewWithIcon(imageName: "waterlevel", value: entry.level, trend: true)
                
            }.padding()
        }
        

    }
}

@main
struct EWWidgets: Widget {
    let kind: String = "EWWidgets"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            EWWidgetsEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct EWWidgets_Previews: PreviewProvider {
    static var previews: some View {
        let entry = SimpleEntry(date: Date(),
                                       air: "+2",
                                       water: "+12",
                                       level: "140cm")
        
        return Group {
            
            EWWidgetsEntryView(entry: entry)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            
            EWWidgetsEntryView(entry: entry)
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            
            EWWidgetsEntryView(entry: entry)
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
        
    }
}
