//
//  Measurements.swift
//  EW
//
//  Created by Ilya on 25.11.20.
//

import Foundation

// https://isarmeasurements.azurewebsites.net/api/measurements?from=2020-07-01&to=2020-07-02

// MARK: - Measurements
class Measurements: Codable {
    var temperature, level, pressure, airTemperature: [Measurement]?

    init(temperature: [Measurement]?, level: [Measurement]?, pressure: [Measurement]?, airTemperature: [Measurement]?) {
        self.temperature = temperature
        self.level = level
        self.pressure = pressure
        self.airTemperature = airTemperature
    }
}

// MARK: - Measurement
class Measurement: Codable {
    var date: Date
    var value: Double

    init(date: Date, value: Double) {
        self.date = date
        self.value = value
    }
}
