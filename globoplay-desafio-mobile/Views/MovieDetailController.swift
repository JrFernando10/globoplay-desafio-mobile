//
//  MovieDetailController.swift
//  globoplay-desafio-mobile
//
//  Created by Fernando on 24/01/25.
//

import UIKit

class MovieDetailController: UIViewController {
    private let movie: Movie
    private var isFavorite: Bool
    private let viewModel = MovieListViewModel()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = movie.title
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var overviewLabel: UILabel = {
        let label = UILabel()
        label.text = movie.overview
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var detailsLabel: UILabel = {
        let label = UILabel()
        label.text = "Ficha técnica"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var technicalDetailsLabel: UILabel = {
        let label = UILabel()
        label.text = """
        Título Original: \(movie.title)
        Idioma: \(movie.original_language)
        Ano de produção: \(movie.release_date)
        Nota: \(String(format: "%.1f", movie.vote_average))
        """
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var watchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Assista", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(isFavorite ? "Remover dos Favoritos" : "Adicionar aos Favoritos", for: .normal)
        button.backgroundColor = isFavorite ? .systemRed : .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    init(movie: Movie) {
        self.movie = movie
        self.isFavorite = FavoriteManager.shared.loadFavoriteMovies().contains(where: { $0.id == movie.id })
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadPosterImage()
    }

    private func setupUI() {
        view.backgroundColor = .white

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(overviewLabel)
        contentView.addSubview(detailsLabel)
        contentView.addSubview(technicalDetailsLabel)
        contentView.addSubview(watchButton)
        contentView.addSubview(favoriteButton)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            posterImageView.heightAnchor.constraint(equalToConstant: 300),

            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            overviewLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            overviewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            detailsLabel.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 24),
            detailsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            detailsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            technicalDetailsLabel.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor, constant: 8),
            technicalDetailsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            technicalDetailsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            watchButton.topAnchor.constraint(equalTo: technicalDetailsLabel.bottomAnchor, constant: 24),
            watchButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            watchButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            watchButton.heightAnchor.constraint(equalToConstant: 50),

            favoriteButton.topAnchor.constraint(equalTo: watchButton.bottomAnchor, constant: 16),
            favoriteButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            favoriteButton.heightAnchor.constraint(equalToConstant: 50),
            favoriteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }

    private func loadPosterImage() {
        viewModel.loadImage(for: movie) { [weak self] image in
            self?.posterImageView.image = image
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
    }

    private func updateFavoriteButton() {
        favoriteButton.setTitle(isFavorite ? "Remover dos Favoritos" : "Adicionar aos Favoritos", for: .normal)
        favoriteButton.backgroundColor = isFavorite ? .systemRed : .systemGreen
    }
}
