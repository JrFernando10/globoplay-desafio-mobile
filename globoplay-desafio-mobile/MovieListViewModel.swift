//
//  MovieListViewModel.swift
//  globoplay-desafio-mobile
//
//  Created by Fernando on 24/01/25.
//

import Foundation

class MovieListViewModel {
    private var movies: [Movie] = []
    var filteredMovies: [Movie] = []
    private var currentPage = 1
    private var totalPages = 1
    var onMoviesUpdated: (() -> Void)?
    private var isSearchActive = false

    init() {
        fetchMovies()
    }

    func fetchMovies() {
        NetworkService.shared.fetchMovies(page: currentPage) { [weak self] result in
            switch result {
            case .success(let response):
                self?.movies.append(contentsOf: response.results)
                self?.filteredMovies = self?.movies ?? []
                self?.totalPages = response.total_pages
                
                DispatchQueue.main.async {
                    self?.onMoviesUpdated?()
                }
                
            case .failure(let error):
                print("Error fetching movies: \(error.localizedDescription)")
            }
        }
    }

    func loadNextPage() {
        if currentPage < totalPages && !isSearchActive {
            currentPage += 1
            fetchMovies()
        }
    }

    func filterMovies(searchText: String) {
        isSearchActive = !searchText.isEmpty
        filteredMovies = searchText.isEmpty ? movies : movies.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        DispatchQueue.main.async {
            self.onMoviesUpdated?()
        }
    }
}
