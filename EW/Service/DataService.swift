//
//  DataService.swift
//  EW
//
//  Created by Ilya on 28.10.20.
//

import Foundation
import Combine

protocol WebServiceType {
    func get(for url: URL) -> AnyPublisher<String?, Error>
    
}

class DataService: WebServiceType {
    
    func get(for url: URL) -> AnyPublisher<String?, Error> {
       
        var request: URLRequest = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map() {
                return String(data: $0.data, encoding: .ascii)
            }
            .catch { error in
                Fail(error: error).eraseToAnyPublisher()
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
