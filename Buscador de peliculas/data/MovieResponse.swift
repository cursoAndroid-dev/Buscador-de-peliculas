//
//  MovieResponse.swift
//  Buscador de peliculas
//
//  Created by Mananas on 4/12/25.
//

import Foundation

// Resultado de la búsqueda (lista)
struct MovieResponse: Codable {
    let Search: [MovieSearchItem]
    let Response: String
}

// Modelo que usa SOLO la lista de la pantalla principal
struct MovieSearchItem: Codable {
    let Title: String
    let Year: String
    let imdbID: String
    let Poster: String
}

// Modelo para el DETALLE
struct MovieDetail: Codable {
    let Title: String?
    let Year: String?
    let Rated: String?
    let Released: String?
    let Runtime: String?
    let Genre: String?
    let Director: String?
    let Writer: String?
    let Actors: String?
    let Plot: String?
    let Language: String?
    let Country: String?
    let Awards: String?
    let Poster: String?
    let Ratings: [Rating]?
    let Metascore: String?
    let imdbRating: String?
    let imdbVotes: String?
    let imdbID: String?
    let totalSeasons: String?
    let Response: String?
}

// Ratings (Rotten Tomatoes, IMDb, etc)
struct Rating: Codable {
    let Source: String?
    let Value: String?
}
