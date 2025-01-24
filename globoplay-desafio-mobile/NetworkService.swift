//
//  NetworkService.swift
//  globoplay-desafio-mobile
//
//  Created by Fernando on 24/01/25.
//

import Foundation

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

class NetworkService {
    static let shared = NetworkService()

    private init() {}

    func fetchMovies(page: Int, completion: @escaping (Result<MovieResponse, Error>) -> Void) {
        let urlString = "\(APIConstants.baseURL)/movie/popular"
        var components = URLComponents(string: urlString)
        components?.queryItems = [
            URLQueryItem(name: "api_key", value: APIConstants.apiKey),
            URLQueryItem(name: "page", value: "\(page)")
        ]

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

            do {
                let decoder = JSONDecoder()
                let movieResponse = try decoder.decode(MovieResponse.self, from: data)
                completion(.success(movieResponse))
            } catch {
                completion(.failure(NetworkError.decodingError))
            }
        }

        task.resume()
    }
}
