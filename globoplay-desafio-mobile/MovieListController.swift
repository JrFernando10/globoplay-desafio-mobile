//
//  ViewController.swift
//  globoplay-desafio-mobile
//
//  Created by Fernando on 24/01/25.
//

import UIKit

class MovieListController: UIViewController {
    private let viewModel = MovieListViewModel()
    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    private var myListController = MyListController()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
    }

    private func setupUI() {
        view.backgroundColor = .white
        title = "Filmes"

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

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Minha Lista", style: .plain, target: self, action: #selector(openMyList))
    }

    @objc private func openMyList() {
        navigationController?.pushViewController(myListController, animated: true)
    }

    private func setupViewModel() {
        viewModel.onMoviesUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        viewModel.fetchMovies()
    }
}

extension MovieListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredMovies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell else {
            return UITableViewCell()
        }
        
        let movie = viewModel.filteredMovies[indexPath.row]
        
        cell.configure(with: movie, isFavorite: myListController.favoriteMovies.contains(where: { $0.id == movie.id }))
        cell.onFavoriteTapped = { [weak self] in
            self?.myListController.addFavoriteMovie(movie)
        }
        
        return cell
    }
}

extension MovieListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = viewModel.filteredMovies[indexPath.row]
        let detailController = MovieDetailController(movie: movie)
        present(detailController, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.filteredMovies.count - 1 {
            viewModel.loadNextPage()
        }
    }
}
