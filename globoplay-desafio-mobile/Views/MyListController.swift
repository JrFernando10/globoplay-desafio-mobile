//
//  MyListController.swift
//  globoplay-desafio-mobile
//
//  Created by Fernando on 24/01/25.
//

import UIKit

protocol MyListControllerDelegate: AnyObject {
    func didUpdateFavorites()
}

class MyListController: UIViewController {
    private let viewModel = MovieListViewModel()
    weak var delegate: MyListControllerDelegate?
    private let tableView = UITableView()
    private let emptyStateLabel = UILabel()
    
    private(set) var favoriteMovies: [Movie] = [] {
        didSet {
            updateUI()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadFavoriteMovies()
        NotificationCenter.default.addObserver(self, selector: #selector(updateFavorites), name: .favoritesUpdated, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavoriteMovies()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateUI()
    }
    
    @objc private func updateFavorites() {
        favoriteMovies = FavoriteManager.shared.loadFavoriteMovies()
        DispatchQueue.main.async {
            self.updateUI()
        }
    }
    
    private func setupUI() {
        title = "Minha Lista"

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MovieFavoriteCell.self, forCellReuseIdentifier: MovieFavoriteCell.identifier)
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        emptyStateLabel.text = "Sua lista está vazia"
        emptyStateLabel.textColor = .gray
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.isHidden = true
        view.addSubview(emptyStateLabel)
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func updateUI() {
        emptyStateLabel.isHidden = !favoriteMovies.isEmpty
        title = favoriteMovies.isEmpty ? "Lista Vazia" : "Minha Lista"
        tableView.reloadData()
    }

    func loadFavoriteMovies() {
        favoriteMovies = FavoriteManager.shared.loadFavoriteMovies()
        DispatchQueue.main.async {
            self.updateUI()
        }
    }
    
    func addFavoriteMovie(_ movie: Movie) {
        guard !favoriteMovies.contains(where: { $0.id == movie.id }) else { return }
        favoriteMovies.append(movie)
        updateUI()
        delegate?.didUpdateFavorites()
    }

    func removeFavoriteMovie(_ movie: Movie) {
        guard let index = favoriteMovies.firstIndex(where: { $0.id == movie.id }) else { return }
        favoriteMovies.remove(at: index)
        FavoriteManager.shared.removeFavoriteMovie(movie)
        updateUI()
        delegate?.didUpdateFavorites()
    }
}

extension MyListController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteMovies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieFavoriteCell.identifier, for: indexPath) as? MovieFavoriteCell else {
            return UITableViewCell()
        }
        
        let movie = favoriteMovies[indexPath.row]
        
        viewModel.loadImage(for: movie) { image in
            DispatchQueue.main.async {
                cell.delegate = self
                cell.configure(with: movie, isFavorite: true, image: image)
            }
        }
        
        return cell
    }
       
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 120
     }
     
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let movie = favoriteMovies[indexPath.row]
         let detailController = MovieDetailController(movie: movie)
         detailController.delegate = self
         detailController.modalPresentationStyle = .formSheet
         present(detailController, animated: true, completion: nil)
     }
}

extension MyListController: MovieDetailControllerDelegate {
    func didUpdateFavorites() {
        DispatchQueue.main.async {
            self.loadFavoriteMovies()
            self.updateUI()
        }
    }
}

extension MyListController: MovieFavoriteCellDelegate {
    func didTapFavoriteButton(for movie: Movie) {
        removeFavoriteMovie(movie)
    }
}


extension Notification.Name {
    static let favoritesUpdated = Notification.Name("favoritesUpdated")
}
