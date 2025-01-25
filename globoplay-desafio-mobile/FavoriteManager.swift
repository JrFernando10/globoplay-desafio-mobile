//
//  FavoriteManager.swift
//  globoplay-desafio-mobile
//
//  Created by Fernando on 24/01/25.
//

import Foundation

class FavoriteManager {
    static let shared = FavoriteManager()
    private var favoriteMovies: [Movie] = []

    private init() {}

    func addFavoriteMovie(_ movie: Movie) {
        if !favoriteMovies.contains(where: { $0.id == movie.id }) {
            favoriteMovies.append(movie)
        }
    }

    func removeFavoriteMovie(_ movie: Movie) {
        favoriteMovies.removeAll { $0.id == movie.id }
    }

    func loadFavoriteMovies() -> [Movie] {
        return favoriteMovies
    }
}
