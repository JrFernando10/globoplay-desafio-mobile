//
//  MyListController.swift
//  globoplay-desafio-mobile
//
//  Created by Fernando on 24/01/25.
//

import UIKit

class MyListController: UIViewController {
    var favoriteMovies: [Movie] = [] {
        didSet {
            FavoriteManager.shared.saveFavoriteMovies(favoriteMovies)
            tableView.reloadData()
        }
    }

    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadFavoriteMovies()
    }

    private func setupUI() {
        view.backgroundColor = .white
        title = "Minha Lista"

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.identifier)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func loadFavoriteMovies() {
        favoriteMovies = FavoriteManager.shared.loadFavoriteMovies()
    }

    func addFavoriteMovie(_ movie: Movie) {
        if !favoriteMovies.contains(where: { $0.id == movie.id }) {
            favoriteMovies.append(movie)
        }
    }

    func removeFavoriteMovie(_ movie: Movie) {
        favoriteMovies.removeAll { $0.id == movie.id }
    }
}

extension MyListController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteMovies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell else {
            return UITableViewCell()
        }
        
        let movie = favoriteMovies[indexPath.row]
        cell.configure(with: movie, isFavorite: true)
        cell.onFavoriteTapped = { [weak self] in
            self?.removeFavoriteMovie(movie)
        }
        
        return cell
    }
}
