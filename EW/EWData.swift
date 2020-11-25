//
//  EWData.swift
//  EW
//
//  Created by Ilya on 26.10.20.
//

import Foundation
import SwiftSoup
import Combine

struct EWPaths {
    private static let baseUrl = "https://www.gkd.bayern.de"
    enum paths: String {
        case airUrl = "/de/meteo/lufttemperatur/isar/eichenried-200114/messwerte/tabelle"
        case waterUrl = "/de/fluesse/wassertemperatur/isar/muenchen-himmelreichbruecke-16515005/messwerte/tabelle"
        case waterLevel = "/de/fluesse/wasserstand/isar/muenchen-himmelreichbruecke-16515005/messwerte/tabelle"
        case presureUrl = "/de/fluesse/abfluss/isar/muenchen-himmelreichbruecke-16515005/messwerte/tabelle"
    }
    static func getUrlStr(p: paths) -> String {
        return baseUrl + p.rawValue
    }

}

enum AppError: Error {
    case impossible
}

protocol DataHandler {
    func setUrl(urlStr: String)
    func setPeriodFrom(days:Int)
    
    func getAirPublisher() -> AnyPublisher<String?, Error>
    func getWaterPublisher() -> AnyPublisher<String?, Error>
    func getPreasurePublisher() -> AnyPublisher<String?, Error>
    func getLevelPublisher() -> AnyPublisher<String?, Error>
}

class HttpGetter: DataHandler {

    private var url: URL?
    private var service: WebServiceType
    private var period: Int = 0
    
    init(service: WebServiceType) {
        self.service = service
    }
    
    func setUrl(urlStr: String) {
        guard let URL = URL.init(string: urlStr) else {
            return
        }
        url = URL
    }

    func getAirPublisher() -> AnyPublisher<String?, Error> {
        setUrl(urlStr: EWPaths.getUrlStr(p: .airUrl))
        return getStringPublisher()
    }
    func getWaterPublisher() -> AnyPublisher<String?, Error> {
        setUrl(urlStr: EWPaths.getUrlStr(p: .waterUrl))
        return getStringPublisher()
    }
    
    func getPreasurePublisher() -> AnyPublisher<String?, Error> {
        setUrl(urlStr: EWPaths.getUrlStr(p: .presureUrl))
        return getStringPublisher()
    }
    
    func getLevelPublisher() -> AnyPublisher<String?, Error> {
        setUrl(urlStr: EWPaths.getUrlStr(p: .waterLevel))
        return getStringPublisher()
    }
    
    func setPeriodFrom(days:Int) {
        self.period = days
    }
    
    private func getStringPublisher() -> AnyPublisher<String?, Error> {
        
        if let urlWithPeriod = getUrlWithPeriod() {
            return  Just("").mapError({ _ in  AppError.impossible })
                .eraseToAnyPublisher()
            
            //service.get(for: urlWithPeriod)
        } else {
            return Fail(error: AppError.impossible).eraseToAnyPublisher()
        }
    }
    
    private func getUrlWithPeriod() -> URL? {
        
        var dayComponent = DateComponents()
        dayComponent.day = period
        let theCalendar = Calendar.current
        let d2 = theCalendar.date(byAdding: dayComponent, to: Date())!

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        let beginn = dateFormatter.string(from: d2)
        let ende = dateFormatter.string(from: Date())
        
        let queryItems = [URLQueryItem(name: "beginn", value: beginn), URLQueryItem(name: "ende", value: ende)]
        
        if url != nil {
            var urlComps = URLComponents(url: url!, resolvingAgainstBaseURL: true)!
            
            urlComps.queryItems = queryItems
            
            return urlComps.url
        } else  {
            fatalError("url is empty")
        }
    }
}

class Parser {
    private var content: String
    
    init(html: String) {
        content = html
    }
    
    func parse() -> [Date: Float] {
        let dateFormatter = DateFormatter()
        
        do {
            let doc: Document = try SwiftSoup.parse(content)
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
            return data
        } catch {
            return [:]
        }
    }
    
}

