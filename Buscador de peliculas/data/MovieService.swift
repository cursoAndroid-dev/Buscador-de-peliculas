//
//  MovieService.swift
//  Buscador de peliculas
//
//  Created by Mananas on 4/12/25.
//

import Foundation

class MovieService {

    private let apiKey = "deaa3a5a"

    // PETICIÓN DE BÚSQUEDA
    func fetchMovies(searchText: String, completion: @escaping (Result<[MovieSearchItem], Error>) -> Void) {

        let urlString = "https://www.omdbapi.com/?apikey=\(apiKey)&s=\(searchText)"

        guard let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encoded) else {
            completion(.failure(NSError(domain: "URL ERROR", code: -1)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in

            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "NO DATA", code: -1)))
                return
            }

            do {
                let decoded = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(.success(decoded.Search))
            } catch {
                completion(.failure(error))
            }

        }.resume()
    }

    // PETICIÓN DE DETALLE
    func fetchMovieDetail(imdbID: String, completion: @escaping (Result<MovieDetail, Error>) -> Void) {

        let urlString = "https://www.omdbapi.com/?apikey=\(apiKey)&i=\(imdbID)&plot=full"

        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "URL error", code: -1)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in

            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -1)))
                return
            }

            do {
                let decoder = JSONDecoder()
                let detail = try decoder.decode(MovieDetail.self, from: data)
                completion(.success(detail))
            } catch {
                print(" ERROR DECODIFICANDO DETALLE")
                    print("JSON recibido del detalle:")
                    print(String(data: data, encoding: .utf8) ?? "")
                    print("ERROR: \(error.localizedDescription)")
                    completion(.failure(error))
            }

        }.resume()
    }
}
