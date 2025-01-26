//
//  MovieDetailController.swift
//  globoplay-desafio-mobile
//
//  Created by Fernando on 24/01/25.
//

import UIKit

protocol MovieDetailControllerDelegate: AnyObject {
    func didUpdateFavorites()
}

class MovieDetailController: UIViewController {
    private let movie: Movie
    private var isFavorite: Bool
    private let viewModel = MovieListViewModel()
    weak var delegate: MovieDetailControllerDelegate?

    private lazy var movieDetailView = MovieDetailView(movie: movie, isFavorite: isFavorite)

    init(movie: Movie) {
        self.movie = movie
        self.isFavorite = FavoriteManager.shared.loadFavoriteMovies().contains(where: { $0.id == movie.id })
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = movieDetailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        movieDetailView.favoriteButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        movieDetailView.closeButton.addTarget(self, action: #selector(closeScreen), for: .touchUpInside)
        loadPosterImage()
        updateFavoriteButton()
    }

    private func loadPosterImage() {
        viewModel.loadImage(for: movie) { [weak self] image in
            self?.movieDetailView.posterImageView.image = image
        }
    }

    @objc private func toggleFavorite() {
        if isFavorite {
            FavoriteManager.shared.removeFavoriteMovie(movie)
        } else {
            FavoriteManager.shared.addFavoriteMovie(movie)
        }
        
        isFavorite.toggle()
        updateFavoriteButton()
        
        NotificationCenter.default.post(name: .favoritesUpdated, object: nil) 
        delegate?.didUpdateFavorites()
    }

    private func updateFavoriteButton() {
        movieDetailView.favoriteButton.setTitle(isFavorite ? "Remover dos Favoritos" : "Adicionar aos Favoritos", for: .normal)
        movieDetailView.favoriteButton.backgroundColor = isFavorite ? .systemRed : .systemGreen
    }

    @objc private func closeScreen() {
        dismiss(animated: true, completion: nil)
    }
}
