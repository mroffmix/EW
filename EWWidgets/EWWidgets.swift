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

        guard let url = URL.init(string: "https://isarmeasurements.azurewebsites.net/api/measurements")
        else { return }
        var request: URLRequest = URLRequest(url: url)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.measureFormat)
        
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            
            if error != nil || data == nil {
                print("Client error!")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                
                return
            }
            
            if let measurements = try? decoder.decode(Measurements.self, from: data!) {
                
                let temp = measurements.temperature?.first?.value
                let level = measurements.level?.first?.value
                //let pr = measurements.pressure?.first?.value
                let air = measurements.airTemperature?.first?.value
                
                let entry =
                    SimpleEntry(date: Date(),
                                air: "\(air ?? 0)",
                                water: "\(temp ?? 0)",
                                level: "\(level ?? 0)")
                
                completion(entry)
            }
        }
        .resume()

    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        let currentDate = Date()
        let entryDate = Calendar.current.date(byAdding: .minute, value: 20, to: currentDate)!
        
        
        guard let url = URL.init(string: "https://isarmeasurements.azurewebsites.net/api/measurements")
        else { return }
        var request: URLRequest = URLRequest(url: url)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.measureFormat)
        
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            
            if error != nil || data == nil {
                print("Client error!")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                return
            }
            
            if let measurements = try? decoder.decode(Measurements.self, from: data!) {
                
                let temp = measurements.temperature?.first?.value
                let level = measurements.level?.first?.value
                //let pr = measurements.pressure?.first?.value
                let air = measurements.airTemperature?.first?.value
                
                let entry =
                    SimpleEntry(date: entryDate,
                                air: "\(air ?? 0) \(IndicatorType.air.getStr())",
                                water: "\(temp ?? 0) \(IndicatorType.water.getStr())",
                                level: "\(level ?? 0) \(IndicatorType.level.getStr())")
                
                entries.append(entry)
                
                let timeline = Timeline(entries: entries, policy: .atEnd)
                completion(timeline)
            }
        }
        .resume()
        
        
        
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
