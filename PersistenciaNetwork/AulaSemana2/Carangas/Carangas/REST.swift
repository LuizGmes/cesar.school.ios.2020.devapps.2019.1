//
//  REST.swift
//  Carangas
//
//  Created by Douglas Frari on 29/05/20.
//  Copyright © 2020 CESAR School. All rights reserved.
//

import Foundation
import Alamofire


enum CarError {
    case url
    case taskError(error: Error)
    case noResponse
    case noData
    case responseStatusCode(code: Int)
    case invalidJSON
}

enum RESTOperation {
    case save
    case update
    case delete
}

final class REST {
    
    // URL principal + endpoint
    private static let basePath = "https://carangas.herokuapp.com/cars"
    
    // session criada automaticamente e disponivel para reusar
    private static let session = URLSession(configuration: configuration) // URLSession.shared
    
    private static let configuration: URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        config.allowsCellularAccess = true
        config.httpAdditionalHeaders = ["Content-Type":"application/json"]
        config.timeoutIntervalForRequest = 10.0
        config.httpMaximumConnectionsPerHost = 5
        return config
    }()
    
    
    class func loadBrands(onComplete: @escaping ([Brand]) -> Void, onError: @escaping (CarError) -> Void) {
        
        // URL TABELA FIPE

        let urlFipe = "https://fipeapi.appspot.com/api/1/carros/marcas.json"
        
        AF.request(urlFipe).response { response in

        do {
                if response.data == nil {
                    onError(.noData)
                    return
                }
            
                if let error = response.error {
                    
                    if error.isSessionTaskError || error.isInvalidURLError {
                        onError(.url)
                        return
                    }
                    
                    if error._code == NSURLErrorTimedOut {
                        onError(.noResponse)
                    } else if error._code != 200 {
                        onError(.responseStatusCode(code: error._code))
                    }
                }
            
                let brands = try JSONDecoder().decode([Brand].self, from: response.data!)
                    onComplete(brands)
                } catch is DecodingError {
                    onError(.invalidJSON)
                } catch {
                    onError(.taskError(error: error))
                }
            
            }
        
    }
    
    
    
    class func loadCars(onComplete: @escaping ([Car]) -> Void, onError: @escaping (CarError) -> Void) {
        
        AF.request(self.basePath).response { response in
            
            do {
                if response.data == nil {
                    onError(.noData)
                    return
                }
                
                if let error = response.error {
                    
                    if error.isSessionTaskError || error.isInvalidURLError {
                        onError(.url)
                        return
                    }
                    
                    if error._code == NSURLErrorTimedOut {
                        onError(.noResponse)
                    } else if error._code != 200 {
                        onError(.responseStatusCode(code: error._code))
                    }
                }
                
                let cars = try JSONDecoder().decode([Car].self, from: response.data!)
                onComplete(cars)
            } catch is DecodingError {
                onError(.invalidJSON)
            } catch {
                onError(.taskError(error: error))
            }
            
        }
    }
    
    
    
    class func save(car: Car, onComplete: @escaping (Bool) -> Void, onError: @escaping (CarError) -> Void) {
        applyOperation(car: car, operation: .save, onComplete: onComplete, onError: onError)
    }
    
    class func update(car: Car, onComplete: @escaping (Bool) -> Void, onError: @escaping (CarError) -> Void) {
        applyOperation(car: car, operation: .update, onComplete: onComplete, onError: onError)
    }
    
    class func delete(car: Car, onComplete: @escaping (Bool) -> Void, onError: @escaping (CarError) -> Void) {
        applyOperation(car: car, operation: .delete, onComplete: onComplete, onError: onError)
    }
    
    
    
    private class func applyOperation(car: Car, operation: RESTOperation , onComplete: @escaping (Bool) -> Void, onError: @escaping (CarError) -> Void) {
        
        // o endpoint do servidor para update é: URL/id
        let urlString = basePath + "/" + (car._id ?? "")
        
    
        var httpMethod: HTTPMethod = .get
        
        switch operation {
        case .delete:
            httpMethod = HTTPMethod.delete
        case .save:
            httpMethod = HTTPMethod.post
        case .update:
            httpMethod = HTTPMethod.put
        }
        
        
        // transformar objeto para um JSON, processo contrario do decoder -> Encoder
        guard let json = try? JSONEncoder().encode(car) else {
            onComplete(false)
            return
        }
        
        
        AF.request(urlString, method: httpMethod, parameters: json).response { response in
            
            if response.error != nil {
                onComplete(false)
                return
            }
            
            onComplete(true)
            
        }
            
    }
    
} // fim da classe
