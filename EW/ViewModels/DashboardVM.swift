//
//  DashboardVM.swift
//  EW
//
//  Created by Ilya on 27.10.20.
//

import Foundation
import Combine
import SwiftUI

enum IndicatorType {
    case air
    case water
    case level
    case pressure
    
    func getStr() -> String {
        switch self {
        case .air:
            return "°C"
        case .water:
            return "°C"
        case .level:
            return "cm"
        case .pressure:
            return "m³/s"
        }
    }
}

struct Indicator {
    var value: Double = 0
    var stringValue: String {
        String(format: "%.1f", value)
    }
    var preValue: Double = 0
    var trend: Bool {
        value > preValue
    }
}

struct LegendDescription {
    var min: Double = 0
    var max: Double = 0
    var start: Date = Date()
    var end: Date = Date()
    var measure: String = ""
}

class DashboardVM: ObservableObject {
    
    @Published var airData: [Double] = []
    @Published var waterData: [Double] = []
    @Published var waterLevelData: [Double] = []
    @Published var pressureData: [Double] = []
    
    @Published var showedData: [Double] = []
    
    @Published var air = Indicator()
    @Published var water = Indicator()
    @Published var level = Indicator()
    @Published var pressure = Indicator()
    
    
    @Published var airL = LegendDescription()
    @Published var waterL = LegendDescription()
    @Published var levelL = LegendDescription()
    @Published var pressureL = LegendDescription()
    
    @Published var currentLegend = LegendDescription()
    
    @Published var isLoading: Bool = true
    
    private var handler: DataHandler
    private var publisher: AnyPublisher<String?, Error>?
    private var subscriptions = Set<AnyCancellable>()
    
    init(handler: DataHandler) {
        self.handler = handler
    }
    
    func showData(with data: [Double], type: IndicatorType)  {

        if showedData.count == 0 {
            showedData = data
        // for one by one updating
        } else {
            for (index, _) in showedData.enumerated() {
                withAnimation(Animation.linear.delay(Double(index))){
                    showedData[index] = data[index]
                }
            }
        }
        
        switch type {
        case .air:
            currentLegend = airL
        case .water:
            currentLegend = waterL
        case .level:
            currentLegend = levelL
        case .pressure:
            currentLegend = pressureL
        }
    }
    
    func onAppear() {
        
        handler.setPeriodFrom(days: -1)
        
        // Air data
        publisher = handler.getAirPublisher()
        publisher?.sink(receiveCompletion: { (error) in
            print("Request failed: \(String(describing: error))")
        }, receiveValue: { [self] html in
            
            let parser = Parser(html: html!)
            let data = parser.parse()
            
            (airData, airL) = getArray(data: data)
            airL.measure = IndicatorType.air.getStr()
            air = getIndicator(data: data)
            showedData = airData
            currentLegend = airL
            
            isLoading = false
            
        }).store(in: &subscriptions)
        
        // Water data
        publisher = handler.getWaterPublisher()
        publisher?.sink(receiveCompletion: { (error) in
            print("Request failed: \(String(describing: error))")
        }, receiveValue: { [self] html in
            
            let parser = Parser(html: html!)
            let data = parser.parse()
            (waterData, waterL) = getArray(data: data)
            water = getIndicator(data: data)
            waterL.measure = IndicatorType.water.getStr()
            
        }).store(in: &subscriptions)
        
        // Level Data
        publisher = handler.getLevelPublisher()
        publisher?.sink(receiveCompletion: { (error) in
            print("Request failed: \(String(describing: error))")
        }, receiveValue: { [self] html in
            
            let parser = Parser(html: html!)
            let data = parser.parse()
            (waterLevelData, levelL) = getArray(data: data)
            level = getIndicator(data: data)
            levelL.measure = IndicatorType.level.getStr()
            
        }).store(in: &subscriptions)
        
        // Preassure data
        publisher = handler.getPreasurePublisher()
        publisher?.sink(receiveCompletion: { (error) in
            print("Request failed: \(String(describing: error))")
        }, receiveValue: { [self] html in
            
            let parser = Parser(html: html!)
            let data = parser.parse()
            (pressureData, pressureL) = getArray(data: data)
            pressure = getIndicator(data: data)
            pressureL.measure = IndicatorType.pressure.getStr()
            
        }).store(in: &subscriptions)
    }
    
    private func getArray(data:[Date : Float]) -> ([Double], LegendDescription) {
        var result: [Double] = []
        for (_,v) in Array(data).sorted(by: {$0.0 > $1.0}) {
            result.append(Double(v))
        }
        var l = LegendDescription()
        
        l.start = Array(data.keys).min()!
        l.end = Array(data.keys).max()!
        l.max = result.max() ?? 0
        l.min = result.min() ?? 0
        
        return (Array(result.reversed()), l)
    }
    
    private func getIndicator(data:[Date : Float]) -> Indicator {
        var copy = data
        
        let lastDate = Array(copy.keys).max()!
        let currValue = Double(copy[lastDate] ?? 0)
        copy.removeValue(forKey: lastDate)
        
        let prevDate = Array(copy.keys).max()!
        let prevValue = Double(copy[prevDate] ?? 0)
        
        copy.removeAll()
        
        return Indicator.init(value: currValue, preValue: prevValue)
    }
    
}
