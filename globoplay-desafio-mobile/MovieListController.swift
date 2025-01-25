//
//  ViewController.swift
//  globoplay-desafio-mobile
//
//  Created by Fernando on 24/01/25.
//

import UIKit

class MovieListController: UIViewController, MyListControllerDelegate, UISearchResultsUpdating {
    private let viewModel = MovieListViewModel()
    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    private var myListController = MyListController()
    private var favoriteMovieIds: Set<Int> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
        setupSearchController()
        myListController.loadFavoriteMovies()
        myListController.delegate = self
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

    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar filmes"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
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
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.viewModel.fetchMovies()
        }
    }

    func didUpdateFavorites() {
        favoriteMovieIds = Set(myListController.favoriteMovies.map { $0.id })
        
        DispatchQueue.main.async {
            if let indexPaths = self.tableView.indexPathsForVisibleRows {
                self.tableView.reloadRows(at: indexPaths, with: .none)
            }
        }
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        viewModel.filterMovies(searchText: searchText)
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
        let isFavorite = favoriteMovieIds.contains(movie.id)
        
        viewModel.loadImage(for: movie) { image in
            DispatchQueue.main.async {
                cell.configure(with: movie, isFavorite: isFavorite, image: image)
            }
        }
        
        cell.onFavoriteTapped = { [weak self] in
            if isFavorite {
                self?.myListController.removeFavoriteMovie(movie)
            } else {
                self?.myListController.addFavoriteMovie(movie)
            }
        }
        
        return cell
    }
}

extension MovieListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = viewModel.filteredMovies[indexPath.row]
        let detailController = MovieDetailController(movie: movie)
        present(detailController, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.filteredMovies.count - 1 {
            DispatchQueue.global(qos: .userInitiated).async {
                self.viewModel.loadNextPage()
            }
        }
    }
}
