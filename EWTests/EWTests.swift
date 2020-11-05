//
//  EWTests.swift
//  EWTests
//
//  Created by Ilya on 26.10.20.
//

import XCTest
import SwiftSoup

@testable import EW

class EWTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testHttpGetter() {
        
        let getter = HttpGetter(service: DataService())
        XCTAssertNotNil(getter)
        
        getter.setPeriodFrom(days: -10)
        let airp = getter.getAirPublisher()
        XCTAssertNotNil(airp)
        
        //            XCTAssertTrue(getter.url.absoluteString.contains("beginn="))
        //            XCTAssertTrue(getter.url.absoluteString.contains("ende="))
        
    }
    
    
    func testExample() throws {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        var dayComponent = DateComponents()
        dayComponent.day = -30
        let theCalendar = Calendar.current
        let endeDate = theCalendar.date(byAdding: dayComponent, to: Date())
        
        let beginn = dateFormatter.string(from: endeDate!)
        let ende = dateFormatter.string(from: Date())
        
        let str = "https://www.gkd.bayern.de/de/fluesse/wassertemperatur/isar/muenchen-tieraerztl-hochschule-16516008/messwerte/tabelle?zr=woche&beginn=\(beginn)&ende=\(ende)"
        
        guard let URLstr = URL.init(string: str) else {
            XCTFail()
            return
        }
        
        do {
            let contents = try String(contentsOf: URLstr, encoding: .ascii)
            let doc: Document = try SwiftSoup.parse(contents)
            let rows = try doc.select("table.tblsort").select("tr")
            var data: [Date:Float] = [:]
            try rows.forEach { (element) in
                if let date = try element.select("td").first()?.text(),
                   let temperature = try element.select("td").last()?.text() {
                    dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
                    
                    if let temValue = Float(temperature.replacingOccurrences(of: ",", with: ".")),
                       let formattedDate = dateFormatter.date(from: date){
                        data[formattedDate] = temValue
                    }
                }
            }
            print(data)
            
            
        } catch {
            XCTFail()
            return
        }
        
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
