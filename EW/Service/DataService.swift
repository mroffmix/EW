//
//  DataService.swift
//  EW
//
//  Created by Ilya on 28.10.20.
//

import Foundation
import Combine

protocol WebServiceType {
    func get(for url: URL) -> AnyPublisher<Measurements, Error>
    
}

class DataService: WebServiceType {
    private let decoder = JSONDecoder()
    
    func get(for url: URL) -> AnyPublisher<Measurements, Error> {
       
        decoder.dateDecodingStrategy = .formatted(DateFormatter.measureFormat)

        var request: URLRequest = URLRequest(url: url)
        
        request.httpMethod = "GET"
                
        return URLSession.shared.dataTaskPublisher(for: request)
            .map {
                $0.data
            }
            .decode(type: Measurements.self, decoder: decoder)
            .catch { error in
                Fail(error: error).eraseToAnyPublisher()
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
