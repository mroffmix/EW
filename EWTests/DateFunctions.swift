//
//  DateFunctions.swift
//  EWTests
//
//  Created by Ilya on 30.10.20.
//

import XCTest

class DateFunctions: XCTestCase {



    func testCount() throws {
        let data = parsedData
        XCTAssert(data.count == 735)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
