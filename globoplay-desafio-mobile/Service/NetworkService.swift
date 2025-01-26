//
//  NetworkService.swift
//  globoplay-desafio-mobile
//
//  Created by Fernando on 24/01/25.
//

import Foundation

class NetworkService {
    static let shared = NetworkService()

    private init() {}

    func fetchMovies(page: Int, completion: @escaping (Result<MovieResponse, Error>) -> Void) {
        let urlString = "\(APIConstants.baseURL)/movie/popular"
        let parameters = ["page": "\(page)"]

        APIClient.shared.request(urlString: urlString, parameters: parameters) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let movieResponse = try decoder.decode(MovieResponse.self, from: data)
                    completion(.success(movieResponse))
                } catch {
                    completion(.failure(NetworkError.decodingError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
