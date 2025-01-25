//
//  FavoriteManager.swift
//  globoplay-desafio-mobile
//
//  Created by Fernando on 24/01/25.
//

import Foundation

class FavoriteManager {
    static let shared = FavoriteManager()
    private let userDefaultsKey = "favoriteMovies"
    private var favoriteMovies: [Movie] = []

    private init() {}

    func addFavoriteMovie(_ movie: Movie) {
        var currentFavorites = loadFavoriteMovies()
        if !currentFavorites.contains(where: { $0.id == movie.id }) {
            currentFavorites.append(movie)
            saveFavoriteMovies(currentFavorites)
        }
    }

    func removeFavoriteMovie(_ movie: Movie) {
        var currentFavorites = loadFavoriteMovies()
        currentFavorites.removeAll { $0.id == movie.id }
        saveFavoriteMovies(currentFavorites)
    }

    func loadFavoriteMovies() -> [Movie] {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey) {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Movie].self, from: data) {
                return decoded
            }
        }
        return []
    }
    
    private func saveFavoriteMovies(_ movies: [Movie]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(movies) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
            UserDefaults.standard.synchronize()  // Força gravação imediata
        }
    }
}
