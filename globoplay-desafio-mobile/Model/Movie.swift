//
//  Movie.swift
//  globoplay-desafio-mobile
//
//  Created by Fernando on 24/01/25.
//

struct Movie: Codable {
    let adult: Bool
    let backdrop_path: String?
    let genre_ids: [Int]
    let id: Int
    let original_language: String
    let original_title: String
    let overview: String
    let popularity: Double
    let poster_path: String?
    let release_date: String
    let title: String
    let video: Bool
    let vote_average: Double
    let vote_count: Int
}

struct MovieResponse: Codable {
    let page: Int
    let results: [Movie]
    let total_pages: Int
    let total_results: Int
}
