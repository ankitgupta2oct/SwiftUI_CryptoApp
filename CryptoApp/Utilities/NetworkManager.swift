//
//  NetworkManager.swift
//  CryptoApp
//
//  Created by apple on 22/07/23.
//

import Foundation
import Combine

class NetworkManager {
    
    enum NetworkError: LocalizedError {
        case badResponse(url: URL)
        case Unknown
        
        var errorDescription: String? {
            switch self {
            case .badResponse(url: let url): return "Bad Response for the URL: \(url)"
            case .Unknown: return "Something went wrong"
            }
        }
    }
    
    static func download(url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({ output in
                try handleURLResponse(output: output, url: url)
            })
            .eraseToAnyPublisher()
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
            
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    static private func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw NetworkError.badResponse(url: url)
        }
        
        return output.data
    }
}
