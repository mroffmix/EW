//
//  DateFormatter.swift
//  EW
//
//  Created by Ilya on 25.11.20.
//

import Foundation

extension DateFormatter {
    
    static let measureFormat: DateFormatter = {
        let formatter = DateFormatter()
        // 2020-11-18T15:26:03.732Z
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.calendar = Calendar(identifier: .iso8601)
        //formatter.timeZone = TimeZone(secondsFromGMT: 0)
        //formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        // 2020-11-18T15:26:03.732Z
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        //formatter.timeZone = TimeZone(secondsFromGMT: 0)
        //formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
