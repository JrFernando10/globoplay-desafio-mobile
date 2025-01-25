//
//  ViewController.swift
//  globoplay-desafio-mobile
//
//  Created by Fernando on 24/01/25.
//

import UIKit

class MovieListController: UIViewController, MyListControllerDelegate, UISearchResultsUpdating {
    private let viewModel = MovieListViewModel()
    private let searchController = UISearchController(searchResultsController: nil)
    private var myListController = MyListController()
    private var favoriteMovieIds: Set<Int> = []

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.width, height: 150)
        layout.minimumLineSpacing = 10

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.identifier)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
        setupSearchController()
        myListController.loadFavoriteMovies()
    }

    private func setupUI() {
        view.backgroundColor = .white
        title = "Filmes"

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
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
            self?.collectionView.reloadData()
        }
        viewModel.fetchMovies()
    }

    func didUpdateFavorites() {
        favoriteMovieIds = Set(myListController.favoriteMovies.map { $0.id })
        collectionView.reloadData()
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        viewModel.filterMovies(searchText: searchText)
    }
}

extension MovieListController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filteredMovies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell else {
            return UICollectionViewCell()
        }
        
        let movie = viewModel.filteredMovies[indexPath.row]
        viewModel.loadImage(for: movie) { image in
            DispatchQueue.main.async {
                cell.configure(with: image ?? UIImage(named: "placeholder"))
            }
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = viewModel.filteredMovies[indexPath.row]
        let detailController = MovieDetailController(movie: movie)
        detailController.modalPresentationStyle = .formSheet
        present(detailController, animated: true)
    }
}
