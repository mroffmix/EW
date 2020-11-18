//
//  SurfersCount.swift
//  EW
//
//  Created by Ilya on 10.11.20.
//

import Foundation

// MARK: - Surfers
class Surfers: Codable {
    var amount: Int?
    var modified: Date?

    init(amount: Int?, modified: Date?) {
        self.amount = amount
        self.modified = modified
    }
}
