//
//  NetworkManager.swift
//  SwiftWithCombine
//
//  Created by Gaurav Sharma on 24/03/24.
//

import Foundation
import Combine
import SwiftUI

// This can be moved under Utility classes
enum APIError: Error {
    case request(message: String)
    case network(message: String)
    case status(message: String)
    case parsing(message: String)
    case other(message: String)
    
    static func map(_ error: Error) -> APIError {
        return (error as? APIError) ?? .other(message: error.localizedDescription)
    }
}

// Protocol for fetching the data from URL
protocol Fetchable {
    func fetchDataFromTypicalNetworkManager<T: Codable>(completion: @escaping (Result<[T], Error>) -> ())
    func fetchDataWithCombine<T>(with url: URLRequest, session: URLSession) -> AnyPublisher<[T],APIError> where T: Decodable
}

extension Fetchable {
    func fetchDataWithCombine<T>(with urlRequest: URLRequest, session: URLSession) -> AnyPublisher<[T],APIError> where T: Decodable {
        guard let url = urlRequest.url else {
            return Fail(error: APIError.request(message: "Invalid URL")).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: URLRequest(url: url))
            .map { $0.data }
            .decode(type: [T].self, decoder: JSONDecoder())
            .mapError { error in
                APIError.network(message: error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
}

// Protocol which defines methods used by Network Manager

protocol DataFetchable {
    func fetchDataList() -> AnyPublisher<[UserDataModel], APIError>
}

// Struct which handles the API calls and conforms to Fetchable Protocol
struct NetworkManager : Fetchable, DataFetchable {
    //Create the session
    let session = URLSession.init(configuration: .default)
    // URL from where data will be fetched
    let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
    
    
    func fetchDataFromTypicalNetworkManager<T: Codable>(completion: @escaping (Result<[T], Error>) -> ()) {
        let urlRequest = URLRequest(url: url)
        // Create the data task
        let dataTask = session.dataTask(with: urlRequest) { data,response,error in
            
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            guard response != nil else {
                return completion(.failure(error!))
            }
            
            guard let data = data else {
                return completion(.failure(error!))
            }
            
            do {
                let responseObject = try JSONDecoder().decode([T].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(responseObject))
                }
            } catch {
                return completion(.failure(error))
            }
        }
        
        dataTask.resume()
    }
    
    func fetchDataList() -> AnyPublisher<[UserDataModel], APIError> {
        let urlRequest = URLRequest(url: url)
        return fetchDataWithCombine(with: urlRequest, session: session)
    }
}
