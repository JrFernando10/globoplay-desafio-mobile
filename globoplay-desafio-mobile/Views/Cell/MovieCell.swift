//
//  MovieCell.swift
//  globoplay-desafio-mobile
//
//  Created by Fernando on 24/01/25.
//

import UIKit

class MovieCell: UITableViewCell {
    static let identifier = "MovieCell"
    private var isFavorite = false
    var onFavoriteTapped: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setupFavoriteButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupFavoriteButton() {
        let favoriteButton = UIButton(type: .system)
        favoriteButton.setImage(UIImage(systemName: isFavorite ? "heart.fill" : "heart"), for: .normal)
        favoriteButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        favoriteButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        accessoryView = favoriteButton
    }

    func configure(with movie: Movie, isFavorite: Bool) {
        textLabel?.text = movie.title
        detailTextLabel?.text = movie.overview
        self.isFavorite = isFavorite
        updateFavoriteButton()
    }

    @objc private func toggleFavorite() {
        isFavorite.toggle()
        updateFavoriteButton()
        onFavoriteTapped?()
    }

    private func updateFavoriteButton() {
        let button = accessoryView as? UIButton
        button?.setImage(UIImage(systemName: isFavorite ? "heart.fill" : "heart"), for: .normal)
    }
}
