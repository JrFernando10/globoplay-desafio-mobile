//
//  MovieFavoriteCell.swift
//  globoplay-desafio-mobile
//
//  Created by Fernando on 25/01/25.
//

import UIKit

protocol MovieFavoriteCellDelegate: AnyObject {
    func didTapFavoriteButton(for movie: Movie)
}

class MovieFavoriteCell: UITableViewCell {
    static let identifier = "MovieFavoriteCell"

    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()

    private let countryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        return label
    }()

    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        return label
    }()

    private let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .red
        return button
    }()

    weak var delegate: MovieFavoriteCellDelegate?
    private var movie: Movie?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(countryLabel)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(favoriteButton)

        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        countryLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            posterImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            posterImageView.widthAnchor.constraint(equalToConstant: 80),
            posterImageView.heightAnchor.constraint(equalToConstant: 120),

            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),

            countryLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            countryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),

            ratingLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            ratingLabel.topAnchor.constraint(equalTo: countryLabel.bottomAnchor, constant: 4),

            favoriteButton.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            favoriteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: 30),
            favoriteButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    func configure(with movie: Movie, isFavorite: Bool, image: UIImage?) {
        self.movie = movie
        titleLabel.text = movie.title
        countryLabel.text = "Idioma: \(movie.original_language)"
        ratingLabel.text = "Nota: \(String(format: "%.1f", movie.vote_average))"
        posterImageView.image = image
        let heartImage = isFavorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        favoriteButton.setImage(heartImage, for: .normal)
    }

    @objc private func favoriteButtonTapped() {
        guard let movie = movie else { return }
        delegate?.didTapFavoriteButton(for: movie)
    }
}
