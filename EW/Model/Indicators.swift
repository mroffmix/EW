//
//  Indicators.swift
//  EW
//
//  Created by Ilya on 25.11.20.
//

import Foundation

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
