//
//  DashboardVM.swift
//  EW
//
//  Created by Ilya on 27.10.20.
//

import Foundation
import Combine
import SwiftUI

struct Charts {
    var month: [Double] = []
    var week: [Double] = []
    var day: [Double] = []
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
    private var publisher: AnyPublisher<Measurements, Error>?
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
        
        let service = DataService()
        guard let url = URL.init(string: "https://isarmeasurements.azurewebsites.net/api/measurements") else {
            return
        }
        
        publisher = service.get(for: url)
        
        publisher?.sink(receiveCompletion: { (error) in
            print("Request failed: \(String(describing: error))")
        }, receiveValue: { [self] (measurements) in
            
            airData = measurements.airTemperature?.map {$0.value} ?? []
            waterData = measurements.temperature?.map {$0.value} ?? []
            waterLevelData = measurements.level?.map {$0.value} ?? []
            pressureData = measurements.pressure?.map {$0.value} ?? []
            
            
            (airData, airL) = getArray(data: measurements.airTemperature ?? [])
            airL.measure = IndicatorType.air.getStr()
            air = getIndicator(data: measurements.airTemperature ?? [])
            
            showedData = airData
            currentLegend = airL
            isLoading = false
            
            (waterData, waterL) = getArray(data: measurements.temperature ?? [])
            waterL.measure = IndicatorType.water.getStr()
            water = getIndicator(data: measurements.temperature ?? [])
            
            (waterLevelData, levelL) = getArray(data: measurements.level ?? [])
            levelL.measure = IndicatorType.level.getStr()
            level = getIndicator(data: measurements.level ?? [])
            
            
            (pressureData, pressureL) = getArray(data: measurements.pressure ?? [])
            pressureL.measure = IndicatorType.pressure.getStr()
            pressure = getIndicator(data: measurements.pressure ?? [])
            
            
        }).store(in: &subscriptions)
        
    }
    
    private func getArray(data:[Measurement]) -> ([Double], LegendDescription) {
        let result: [Double] = data.sorted(by: {$0.date > $1.date}).map {$0.value}
        
        var l = LegendDescription()
        
        l.start = data.max{ $0.value < $1.value }!.date
        l.end = data.max{ $0.date < $1.date }!.date
        l.max = data.max{ $0.value < $1.value }!.value
        l.min = data.max{ $0.value > $1.value }!.value
        
        return (result, l)
    }
    
    private func getIndicator(data:[Measurement]) -> Indicator {
       // var copy = data
        
//        let lastDate = Array(copy.keys).max()!
//        let currValue = Double(copy[lastDate] ?? 0)
//        copy.removeValue(forKey: lastDate)
//
//        let prevDate = Array(copy.keys).max()!
//        let prevValue = Double(copy[prevDate] ?? 0)
//
        let second = data.count > 1 ? data[1].value : 0
        
        return Indicator.init(value: data.first?.value ?? 0, preValue: second)
    }
    
}
