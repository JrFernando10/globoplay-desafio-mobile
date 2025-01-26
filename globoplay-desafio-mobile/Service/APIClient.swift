//
//  APIClient.swift
//  globoplay-desafio-mobile
//
//  Created by Fernando on 26/01/25.
//

import Foundation
import UIKit

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case noData
    case decodingError
}

struct APIConstants {
    static let baseURL = "https://api.themoviedb.org/3"
    static let apiKey = "6a1ec6bc6b99191914dd069d68820069"
    static let imageBaseURL = "https://image.tmdb.org/t/p/w500"
}

class APIClient {
    static let shared = APIClient()

    private init() {}

    func request(urlString: String, parameters: [String: String]?, completion: @escaping (Result<Data, Error>) -> Void) {
        var components = URLComponents(string: urlString)
        var queryItems = [URLQueryItem(name: "api_key", value: APIConstants.apiKey)]
        if let parameters = parameters {
            for (key, value) in parameters {
                queryItems.append(URLQueryItem(name: key, value: value))
            }
        }
        components?.queryItems = queryItems
        
        guard let url = components?.url else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }

            completion(.success(data))
        }

        task.resume()
    }
    
    func loadImage(urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}
