//
//  NetworkService.swift
//  Unsplash
//
//  Created by Сергей Чумовских  on 19.01.2022.
//

import Foundation

// Model Error
enum SimpleServiceError: Error {
    case serverError
    case notData
    case decodeError
}

class NetworkService {
    private var components = URLComponents()
    private var session: URLSession
    private var apiKey: String = "7hHSQu3zZEFBYMpN-Sv10FIjSkHvUsuTu3H4rx4tDEQ"
    
    init() {
        let configuration = URLSessionConfiguration.default
        session = URLSession(configuration: configuration)
        components.scheme = "https"
        components.host = "api.unsplash.com"
    }

    // random photos
    func getRandomPhotos(count: Int, completion: @escaping (Result<[ResponseModel], SimpleServiceError>) -> Void) {
            
        components.path = "/photos/random"
        components.queryItems = [
            URLQueryItem(name: "count", value: "\(count)"),
            URLQueryItem(name: "client_id", value: "\(apiKey)")
        ]
        
        let task = session.dataTask(with: URLRequest(url: components.url!)) { data, response, error in
            guard error == nil else {
                completion(.failure(.serverError))
                debugPrint(String(describing: error))
                return
            }
            guard let data = data else {
                completion(.failure(.notData))
                debugPrint(String(describing: error))
                return
            }
            do {
                let model = try JSONDecoder().decode([ResponseModel].self, from: data)
                completion(.success(model))
            } catch {
                completion(.failure(.decodeError))
                debugPrint("Decoding ERROR")
            }
        }
        task.resume()
    }
    
    // search photos
    func searchPhotos(query: String, completion: @escaping (Result<[ResponseModel], SimpleServiceError>) -> Void) {
            
        components.path = "/search/photos"
        components.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "client_id", value: "\(apiKey)")
        ]
        
        let task = session.dataTask(with: URLRequest(url: components.url!)) { data, response, error in
            guard error == nil else {
                completion(.failure(.serverError))
                debugPrint(String(describing: error))
                return
            }
            guard let data = data else {
                completion(.failure(.notData))
                debugPrint(String(describing: error))
                return
            }
            do {
                let model = try JSONDecoder().decode(ResultsModel.self, from: data)
                completion(.success(model.results ?? []))
            } catch {
                completion(.failure(.decodeError))
                debugPrint("Decoding ERROR")
            }
        }
        task.resume()
    }
}
