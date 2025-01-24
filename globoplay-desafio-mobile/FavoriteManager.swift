//
//  FavoriteManager.swift
//  globoplay-desafio-mobile
//
//  Created by Fernando on 24/01/25.
//

import Foundation

class FavoriteManager {
    static let shared = FavoriteManager()
    private let favoritesKey = "favoriteMovies"

    private init() {}

    func saveFavoriteMovies(_ movies: [Movie]) {
        if let encodedData = try? JSONEncoder().encode(movies) {
            UserDefaults.standard.set(encodedData, forKey: favoritesKey)
        }
    }

    func loadFavoriteMovies() -> [Movie] {
        if let savedData = UserDefaults.standard.data(forKey: favoritesKey),
           let decodedMovies = try? JSONDecoder().decode([Movie].self, from: savedData) {
            return decodedMovies
        }
        return []
    }
}
