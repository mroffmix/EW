//
//  ContentView.swift
//  EW
//
//  Created by Ilya on 26.10.20.
//

import SwiftUI
import SwiftUICharts

struct ContentView: View {
    
//    func getData(path: String, count: Int = 80) -> [Double] {
//        let getter = HttpGetter(urlStr: EWPaths.baseUrl + path, service: DataService())
//        let parser = Parser(html: )
//        let data = parser.parce()
//
//        var result: [Double] = []
//        for (_,v) in Array(data).sorted(by: {$0.0 > $1.0}) {
//            result.append(Double(v))
//        }
//        return Array(result.prefix(count).reversed())
//    }
//
//    func getLastValue(path: String, count: Int = 80) -> String {
//        let getter = HttpGetter(urlStr: EWPaths.baseUrl + path, service: DataService())
//        let parser = Parser(getter: getter!)
//        let data = parser.parce()
//        let lastDate = Array(data.keys).max()!
//
//        return String(format: "%.1f", data[lastDate]!)
//    }
    
    private let width =  UIScreen.main.bounds.width
    private let height =  UIScreen.main.bounds.height
    
    @State var data : [Double]
    
    var body: some View {
        
        return Text("")
//
//            TabView {
//
//                VStack {
//
//                    LineView(data: getData(path: EWPaths.airUrl), title: "Air temperature")
//                        .padding()
//
//                    Text("Current value:")
//                        .font(.title)
//                        .bold()
//
//                    Text("\(getLastValue(path: EWPaths.airUrl)) °C")
//                        .font(.system(size: 60))
//                        .bold()
//
//                    Spacer()
//                        .frame(height:150)
//                }
//
//                .tabItem {
//                    Image(systemName: "sun.min")
//                    Text("Air")
//                }
//
//                VStack {
//                    LineView(data: getData(path: EWPaths.waterUrl, count: 300), title: "Water temperature")
//
//                        .padding()
//
//                    Text("Current value:")
//                        .font(.title)
//                        .bold()
//
//                    Text("\(getLastValue(path: EWPaths.waterUrl)) °C")
//                        .font(.system(size: 60))
//                        .bold()
//
//                    Spacer()
//                        .frame(height:150)
//                }
//                .tabItem {
//                    Image(systemName: "thermometer")
//                    Text("Water")
//                }
//
//                VStack {
//                    LineView(data: getData(path: EWPaths.waterLevel, count: 40), title: "Water level")
//                        .padding()
//
//                    Text("Current value:")
//                        .font(.title)
//                        .bold()
//
//                    Text("\(getLastValue(path: EWPaths.waterLevel)) cm")
//                        .font(.system(size: 60))
//                        .bold()
//
//                    Spacer()
//                        .frame(height:150)
//                }
//                .tabItem {
//                    Image(systemName: "line.horizontal.3.decrease")
//                    Text("Water level")
//                }
//
//                VStack {
//                    LineView(data: getData(path: EWPaths.presureUrl, count: 40), title: "Pressure")
//                        .padding()
//
//                    Text("Current value:")
//                        .font(.title)
//                        .bold()
//
//                    Text("\(getLastValue(path: EWPaths.presureUrl)) m³/s")
//                        .font(.system(size: 60))
//                        .bold()
//
//                    Spacer()
//                        .frame(height:150)
//                }
//                .tabItem {
//                    Image(systemName: "line.horizontal.3.decrease.circle")
//                    Text("Pressure")
//                }
//
//            }
//
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(data: [])
    }
}
