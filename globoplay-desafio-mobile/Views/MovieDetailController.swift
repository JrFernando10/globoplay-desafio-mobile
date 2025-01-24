//
//  MovieDetailController.swift
//  globoplay-desafio-mobile
//
//  Created by Fernando on 24/01/25.
//

import UIKit

class MovieDetailController: UIViewController {
    private let movie: Movie

    init(movie: Movie) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .white

        let titleLabel = UILabel()
        titleLabel.text = movie.title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        let overviewLabel = UILabel()
        overviewLabel.text = movie.overview
        overviewLabel.numberOfLines = 0
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(overviewLabel)

        let closeButton = UIButton(type: .system)
        closeButton.setTitle("Fechar", for: .normal)
        closeButton.addTarget(self, action: #selector(closeModal), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            closeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc private func closeModal() {
        dismiss(animated: true, completion: nil)
    }
}
